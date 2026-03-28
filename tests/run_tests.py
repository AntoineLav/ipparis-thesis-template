#!/usr/bin/env python3
"""
Test suite for ipparis-thesis LaTeX class.

Tests all combinations of options (phd/hdr, french/english, schools)
and verifies that:
  1. Compilation succeeds (pdflatex exit code 0)
  2. A valid PDF is produced (starts with %PDF-)
  3. Expected strings appear in the PDF text
  4. Unexpected strings do NOT appear

Requires: pdflatex, pdftotext (from poppler-utils)

Usage:
    python3 tests/run_tests.py          # run all tests
    python3 tests/run_tests.py -v       # verbose
    python3 tests/run_tests.py -k hdr   # filter by name
"""

import os
import struct
import subprocess
import shutil
import sys
import tempfile
import zlib
from dataclasses import dataclass, field
from pathlib import Path

# ── Configuration ─────────────────────────────────────────────────

PROJ_DIR = Path(__file__).resolve().parent.parent
CLS_FILE = PROJ_DIR / "ipparis-thesis.cls"
MEDIA_DIR = PROJ_DIR / "media"

SCHOOLS = ["TSP", "TP", "X", "ENSTA", "ENSAE"]
# PONTS excluded: no logo file yet


def make_placeholder_png(path: Path, width=100, height=40):
    """Create a minimal valid 1-color PNG (white) for test compilation."""
    path.parent.mkdir(parents=True, exist_ok=True)

    def _chunk(chunk_type, data):
        c = chunk_type + data
        return struct.pack(">I", len(data)) + c + struct.pack(">I", zlib.crc32(c) & 0xFFFFFFFF)

    ihdr_data = struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)
    raw = b""
    for _ in range(height):
        raw += b"\x00" + b"\xff" * (width * 3)
    idat_data = zlib.compress(raw)

    png = b"\x89PNG\r\n\x1a\n"
    png += _chunk(b"IHDR", ihdr_data)
    png += _chunk(b"IDAT", idat_data)
    png += _chunk(b"IEND", b"")
    path.write_bytes(png)

SCHOOL_NAMES = {
    "TSP": "Télécom SudParis",
    "TP": "Télécom Paris",
    "X": "polytechnique",
    "ENSTA": "ENSTA Paris",
    "ENSAE": "ENSAE Paris",
}


# ── Test infrastructure ──────────────────────────────────────────

@dataclass
class TestResult:
    name: str
    passed: bool
    message: str = ""


@dataclass
class TestCase:
    """A single compilation test."""
    name: str
    options: str  # e.g. "hdr,french"
    school: str
    expect_in_pdf: list = field(default_factory=list)
    expect_not_in_pdf: list = field(default_factory=list)
    extra_preamble: str = ""
    extra_body: str = ""


def generate_tex(tc: TestCase) -> str:
    """Generate a minimal .tex file for the test case."""
    return rf"""
\documentclass[{tc.options}]{{ipparis-thesis}}

\author{{Test Author}}
\titlefr{{Titre de test en français}}
\titleen{{Test title in English}}
\school{{{tc.school}}}
\lab{{TestLab}}
\doctoralschool{{626}}{{Institut Polytechnique de Paris}}{{EDIPP}}
\specialty{{Computer Science}}
\defensedate{{January 1, 2026}}
\defenseplace{{Palaiseau}}
\nnt{{2026IPPA0001}}

\jurymember{{Alice Doe}}{{Professor, MIT}}{{Rapporteur}}
\jurymember{{Bob Smith}}{{Professor, ETH}}{{Examinateur}}

\abstractfr{{Résumé de test en français.}}
\abstracten{{Test abstract in English.}}
\keywordsfr{{mot1, mot2}}
\keywordsen{{word1, word2}}

{tc.extra_preamble}

\begin{{document}}

\frontmatter
\makefrontcover
\makeinnertitle

\begin{{dedication}}
To tests.
\end{{dedication}}

\begin{{acknowledgements}}
Thanks to CI/CD.
\end{{acknowledgements}}

\tableofcontents

\begin{{foreword}}
This is a test document.
\end{{foreword}}

\mainmatter

\chapter{{Test Chapter}}
\label{{ch:test}}

Hello world. This is a test of the ipparis-thesis class with options: {tc.options}, school: {tc.school}.

{tc.extra_body}

\backmatter

\makebackcover

\end{{document}}
"""


def extract_pdf_text(pdf_path: Path) -> str:
    """Extract text from PDF using pdftotext."""
    try:
        result = subprocess.run(
            ["pdftotext", "-layout", str(pdf_path), "-"],
            capture_output=True, text=True, timeout=10,
        )
        return result.stdout
    except FileNotFoundError:
        # pdftotext not available, try Python fallback
        return ""


def run_test(tc: TestCase, verbose: bool = False) -> TestResult:
    """Run a single test case."""
    with tempfile.TemporaryDirectory(prefix="ipparis_test_") as tmpdir:
        tmpdir = Path(tmpdir)

        # Copy class file and generate placeholder logos for tests
        shutil.copy2(CLS_FILE, tmpdir / "ipparis-thesis.cls")
        for name in ["IPPARIS-petit.png", "IPPARIS-petit-blanc.png", "IPPARIS-texte-blanc.png"]:
            make_placeholder_png(tmpdir / "media" / name)
        for school in SCHOOLS:
            make_placeholder_png(tmpdir / "media" / "etab" / f"{school}.png")
        make_placeholder_png(tmpdir / "media" / "ed" / "edipp.png")

        # Write test .tex
        tex_path = tmpdir / "test.tex"
        tex_path.write_text(generate_tex(tc), encoding="utf-8")

        # Compile (two passes for TOC)
        compile_ok = True
        for pass_num in (1, 2):
            result = subprocess.run(
                ["pdflatex", "-interaction=nonstopmode", "-halt-on-error", "test.tex"],
                cwd=tmpdir,
                capture_output=True,
                text=True,
                timeout=60,
            )
            if result.returncode != 0:
                compile_ok = False
                if verbose:
                    # Show last 30 lines of log
                    log = (tmpdir / "test.log").read_text(errors="replace")
                    lines = log.strip().split("\n")
                    err_lines = [l for l in lines if l.startswith("!")]
                    print(f"\n  LOG errors: {err_lines[:5]}")
                break

        if not compile_ok:
            return TestResult(tc.name, False, "Compilation failed")

        # Check PDF exists and is valid
        pdf_path = tmpdir / "test.pdf"
        if not pdf_path.exists():
            return TestResult(tc.name, False, "No PDF produced")

        pdf_bytes = pdf_path.read_bytes()
        if not pdf_bytes.startswith(b"%PDF-"):
            return TestResult(tc.name, False, "Invalid PDF (bad header)")

        if len(pdf_bytes) < 5000:
            return TestResult(tc.name, False, f"PDF too small ({len(pdf_bytes)} bytes)")

        # Extract text and check expectations
        pdf_text = extract_pdf_text(pdf_path)

        if pdf_text:
            for expected in tc.expect_in_pdf:
                if expected not in pdf_text:
                    return TestResult(
                        tc.name, False,
                        f"Expected text not found: '{expected}'"
                    )

            for unexpected in tc.expect_not_in_pdf:
                if unexpected in pdf_text:
                    return TestResult(
                        tc.name, False,
                        f"Unexpected text found: '{unexpected}'"
                    )

        return TestResult(tc.name, True, f"OK ({len(pdf_bytes)} bytes)")


# ── Test definitions ──────────────────────────────────────────────

def build_test_cases() -> list[TestCase]:
    tests = []

    # 1. Compilation tests: every school × (phd, hdr) × (english, french)
    for school in SCHOOLS:
        for doc_type in ["phd", "hdr"]:
            for lang in ["", "french"]:
                opts = doc_type
                if lang:
                    opts += f",{lang}"

                is_french = lang == "french"
                is_hdr = doc_type == "hdr"
                school_name = SCHOOL_NAMES[school]

                expect = [school_name]

                if is_hdr and is_french:
                    expect.append("Habilitation")
                elif is_hdr and not is_french:
                    expect.append("Habilitation")
                elif not is_hdr and is_french:
                    expect.append("doctorat")
                else:
                    expect.append("Doctoral")

                if is_french:
                    expect.append("Composition du Jury")
                else:
                    expect.append("Jury composition")

                # Back cover: both abstracts always present
                expect.append("Test abstract in English")

                name = f"compile_{school}_{doc_type}_{lang or 'english'}"
                tests.append(TestCase(
                    name=name,
                    options=opts,
                    school=school,
                    expect_in_pdf=expect,
                ))

    # 2. Content isolation: HDR french should NOT say "Doctoral Thesis"
    tests.append(TestCase(
        name="hdr_french_no_doctoral",
        options="hdr,french",
        school="TSP",
        expect_in_pdf=["Habilitation"],
        expect_not_in_pdf=["Doctoral Thesis"],
    ))

    # 3. Content isolation: PhD english should NOT say "Habilitation"
    tests.append(TestCase(
        name="phd_english_no_habilitation",
        options="phd",
        school="X",
        expect_in_pdf=["Doctoral"],
        expect_not_in_pdf=["Habilitation"],
    ))

    # 4. Foreword title adapts to language
    tests.append(TestCase(
        name="foreword_french",
        options="hdr,french",
        school="TSP",
        expect_in_pdf=["Avant-propos"],
        expect_not_in_pdf=["Foreword"],
    ))

    tests.append(TestCase(
        name="foreword_english",
        options="hdr",
        school="TP",
        expect_in_pdf=["Foreword"],
        expect_not_in_pdf=["Avant-propos"],
    ))

    # 5. Acknowledgements title adapts to language
    tests.append(TestCase(
        name="ack_french",
        options="phd,french",
        school="ENSTA",
        expect_in_pdf=["Remerciements"],
    ))

    tests.append(TestCase(
        name="ack_english",
        options="phd",
        school="ENSAE",
        expect_in_pdf=["Acknowledgements"],
    ))

    # 6. Author and metadata appear
    tests.append(TestCase(
        name="metadata_present",
        options="hdr,french",
        school="TSP",
        expect_in_pdf=[
            "Test Author",
            "Titre de test",
            "TestLab",
            "2026IPPA0001",
            "Alice Doe",
            "Bob Smith",
            "mot1",
            "word1",
        ],
    ))

    # 7. Cotutelle option compiles
    tests.append(TestCase(
        name="cotutelle_compiles",
        options="phd,french,cotutelle",
        school="TSP",
        extra_preamble=r"\cotutlogo{ENSTA}",
        expect_in_pdf=["Test Author"],
    ))

    # 8. Custom bibstyle option
    tests.append(TestCase(
        name="custom_bibstyle",
        options="phd,bibstyle=numeric",
        school="TSP",
        expect_in_pdf=["Test Author"],
    ))

    # 9. Custom hyperref colors
    tests.append(TestCase(
        name="custom_hyperref_colors",
        options="hdr,linkcolor=red,citecolor=blue,urlcolor=black",
        school="TP",
        expect_in_pdf=["Test Author"],
    ))

    # 10. colorlinks=false option
    tests.append(TestCase(
        name="colorlinks_false",
        options="phd,colorlinks=false",
        school="X",
        expect_in_pdf=["Test Author"],
    ))

    # 11. Multiple custom options combined
    tests.append(TestCase(
        name="combined_custom_options",
        options="hdr,french,bibstyle=alphabetic,bibsorting=nty,linkcolor=black",
        school="ENSAE",
        expect_in_pdf=["Habilitation", "Test Author"],
    ))

    return tests


# ── Main ──────────────────────────────────────────────────────────

def main():
    verbose = "-v" in sys.argv
    filter_key = None
    for i, arg in enumerate(sys.argv):
        if arg == "-k" and i + 1 < len(sys.argv):
            filter_key = sys.argv[i + 1]

    # Check prerequisites
    for cmd in ["pdflatex"]:
        if not shutil.which(cmd):
            print(f"Error: {cmd} not found in PATH")
            sys.exit(1)

    has_pdftotext = shutil.which("pdftotext") is not None
    if not has_pdftotext:
        print("Warning: pdftotext not found — PDF content checks will be skipped")
        print("  Install with: brew install poppler")
        print()

    tests = build_test_cases()

    if filter_key:
        tests = [t for t in tests if filter_key in t.name]

    print(f"Running {len(tests)} tests...\n")

    results = []
    for i, tc in enumerate(tests, 1):
        label = f"[{i:2d}/{len(tests)}] {tc.name}"
        print(f"  {label:55s}", end="", flush=True)

        try:
            result = run_test(tc, verbose=verbose)
        except subprocess.TimeoutExpired:
            result = TestResult(tc.name, False, "Timeout (60s)")
        except Exception as e:
            result = TestResult(tc.name, False, f"Exception: {e}")

        results.append(result)
        status = "PASS" if result.passed else "FAIL"
        symbol = "+" if result.passed else "x"
        print(f" [{symbol}] {status}  {result.message}")

    # Summary
    passed = sum(1 for r in results if r.passed)
    failed = sum(1 for r in results if not r.passed)

    print(f"\n{'='*60}")
    print(f"Results: {passed} passed, {failed} failed, {len(results)} total")

    if failed:
        print(f"\nFailed tests:")
        for r in results:
            if not r.passed:
                print(f"  FAIL  {r.name}: {r.message}")
        sys.exit(1)
    else:
        print("\nAll tests passed!")
        sys.exit(0)


if __name__ == "__main__":
    main()
