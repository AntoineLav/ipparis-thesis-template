# ipparis-thesis v0.6

**LaTeX template for thesis and HDR manuscripts at Institut Polytechnique de Paris.**

A document class that handles official IP Paris covers, French/English switching, and per-school logo selection so you can get on with writing. The covers follow the [IP Paris 2025 graphic charter](https://www.ip-paris.fr/sites/default/files/Charte%20Graphique%202025/IP-PARIS_CHARTE-GRAPHIQUE_2025.pdf) -- Futura Book typeface on the band, correct color palette. **Logo files are not included** due to trademark restrictions -- see [Logo setup](#logo-setup) below.

## About this project

This started when I was writing my HDR at Telecom SudParis and couldn't find a LaTeX template for the actual manuscript. IP Paris only provides Word/LaTeX files for the covers -- nothing for the 100+ pages in between.

I've watched enough PhD students lose time on formatting in the last stretch of their thesis to want to fix that. The idea is simple: pick your school, fill in your metadata, and write. The covers, logos, and language sort themselves out.

All six IP Paris schools share the same cover format, so this works whether you're at Polytechnique, Telecom Paris, ENSTA, ENSAE, Telecom SudParis, or Ponts.

**This is not an official IP Paris template.** It's a personal project I built for my own doctoral students. That said, if it can be useful to others, all the better -- it's open source, and contributions are welcome.

Fair warning: my current position doesn't leave me much time for maintenance. I'll try to answer issues when I can, but please don't expect fast turnaround. If something is broken, a pull request will always be more effective than a bug report.

-- Antoine Lavignotte, 2026

---

## Quick start

```latex
\documentclass[phd]{ipparis-thesis}        % Doctoral thesis (English)
\documentclass[hdr,french]{ipparis-thesis}  % HDR (French)
```

Compile with XeLaTeX (recommended, for Futura Book on the cover band):

```bash
latexmk main.tex
```

Or manually:

```bash
xelatex main
biber main
makeglossaries main
xelatex main
xelatex main
```

The template also compiles with pdflatex, but the cover band will use TeX Gyre Heros instead of Futura Book, which does not match the official IP Paris cover specifications. XeLaTeX is strongly recommended.

---

## Class options

| Option | Description |
|--------|-------------|
| `phd` | Doctoral thesis (default) |
| `hdr` | Habilitation to Supervise Research |
| `english` | English document (default) |
| `french` | French document |
| `cotutelle` | Joint supervision with partner institution |
| `binding` | Add 10mm binding offset for printed copies |
| `bibstyle=...` | Bibliography style (default: `ieee`) |
| `bibsorting=...` | Bibliography sorting (default: `nyt`) |
| `linkcolor=...` | Internal link color (default: `NavyBlue`) |
| `citecolor=...` | Citation link color (default: `ForestGreen`) |
| `urlcolor=...` | URL link color (default: `BrickRed`) |
| `colorlinks=false` | Disable colored links (use boxes instead) |

Options can be combined: `\documentclass[hdr,french,bibstyle=authoryear,linkcolor=black]{ipparis-thesis}`

For packages not covered by the options above (e.g. xcolor, geometry), use `\PassOptionsToPackage` before `\documentclass`:

```latex
\PassOptionsToPackage{table}{xcolor}
\documentclass[phd]{ipparis-thesis}
```

---

## Choosing your school

Use the `\school` command with one of the six member school keys:

```latex
\school{TSP}     % Telecom SudParis
\school{TP}      % Telecom Paris
\school{X}       % Ecole polytechnique
\school{ENSTA}   % ENSTA Paris
\school{ENSAE}   % ENSAE Paris
\school{PONTS}   % Ecole des Ponts ParisTech
```

This automatically:
- Sets the institution name in all covers and title pages
- Displays the correct school logo alongside IP Paris
- Adjusts the "prepared at..." text

To override the institution name (e.g. for a specific wording):

```latex
\school{X}
\institution{l'Ecole polytechnique}  % optional override
```

---

## Metadata

```latex
\author{First Last}
\titlefr{Titre en francais}
\titleen{Title in English}
\school{TSP}
\lab{SAMOVAR}
\doctoralschool{626}{Institut Polytechnique de Paris}{EDIPP}
\specialty{Computer Science, Data, AI}
\defensedate{June 15, 2026}
\defenseplace{Evry}
\nnt{2026IPPAXXXX}
```

---

## Jury

Add jury members one by one. They appear in order on both covers.

```latex
\jurymember{Jane Doe}{Professor, MIT}{Reviewer}
\jurymember{John Smith}{Professor, ETH Zurich}{Reviewer}
\jurymember{Alice Martin}{Professor, Sorbonne}{Examiner}
\jurymember{Bob Dupont}{Professor, IP Paris}{Chair}
```

---

## Abstracts and keywords

Both languages are required (they appear on the back cover in both languages).

```latex
\abstractfr{Resume en francais...}
\abstracten{Abstract in English...}
\keywordsfr{mot1, mot2, mot3}
\keywordsen{keyword1, keyword2, keyword3}
```

---

## Document structure

The template generates three special pages automatically:

1. **`\makefrontcover`** — Official IP Paris front cover (black band with logo and document type, school logo, jury). The band is generated in LaTeX with TikZ -- the text adapts automatically to the document type (thesis/HDR) and language (French/English). Cover text uses Helvetica (sans-serif), matching the official template.
2. **`\makebackcover`** — Official IP Paris back cover (Doctoral School logo at top, bilingual abstracts, IP Paris footer)
3. **`\makeinnertitle`** — *(optional)* Inner title page, for those who want a second, more academic-looking title page

Every page from the acknowledgements onward carries an IP Paris footer: "Institut Polytechnique de Paris / 91120 Palaiseau, France" on the left, and the IP Paris seal on the right. The footer shifts with the binding offset when the `binding` option is active.

Typical `main.tex` structure:

```latex
\documentclass[hdr,french]{ipparis-thesis}

% ... metadata, jury, abstracts ...

\addbibresource{bibliography.bib}
\makeglossaries

\begin{document}

\frontmatter
\makefrontcover

\begin{dedication}
  To my family.
\end{dedication}

\begin{acknowledgements}
  I would like to thank...
\end{acknowledgements}

\tableofcontents
\listoffigures
\listoftables

\begin{foreword}
  This manuscript presents...
\end{foreword}

\mainmatter
\include{chapters/introduction}
\include{chapters/chapter1}
\include{chapters/chapter2}
\include{chapters/perspectives}

\backmatter
\printbibliography[heading=bibintoc]

\appendix
\include{appendices/cv}
\include{appendices/publications}

\makebackcover

\end{document}
```

---

## Provided environments

| Environment | Description |
|-------------|-------------|
| `dedication` | Right-aligned italic dedication page |
| `acknowledgements` | Acknowledgements chapter (auto-titled per language) |
| `foreword` | Foreword / Avant-propos chapter (auto-titled per language) |

---

## Co-tutelle (joint supervision)

```latex
\documentclass[phd,cotutelle]{ipparis-thesis}
\school{TSP}
\cotutlogo{partner}  % place partner.png in media/etab/
```

The partner institution logo appears on the left, the IP Paris school logo on the right.

---

## Customizing covers

The three generated pages (`\makefrontcover`, `\makeinnertitle`, `\makebackcover`) are built from sub-commands that you can override individually with `\renewcommand`. This lets you tweak a specific section without rewriting the entire page.

### Available sub-commands

**Front cover** (`\makefrontcover`):

| Command | What it renders |
|---------|----------------|
| `\frontcoverband` | Black band with IP Paris logo, NNT, and document type |
| `\frontcoverlogos` | School logos (cotutelle partner + main school) |
| `\frontcovercontent` | Text block (title, institution, doctoral school, author) |
| `\frontcoverjury` | Jury table |

**Inner title page** (`\makeinnertitle`):

| Command | What it renders |
|---------|----------------|
| `\innertitlelogos` | ED logo (left) + school and IP Paris logos (right) |
| `\innertitleheader` | Document type, specialty, author, institution |
| `\innertitlebody` | Title between horizontal rules |
| `\innertitlejury` | Defense date and jury table |

**Back cover** (`\makebackcover`):

| Command | What it renders |
|---------|----------------|
| `\backcoverfrench` | French abstract block (title, keywords, abstract) |
| `\backcoverenglish` | English abstract block |
| `\backcoverfooter` | IP Paris name and logo at the bottom |

### Example: custom jury on inner title page

```latex
\makeatletter
\renewcommand{\innertitlejury}{%
  {\small
    Defended on \@defensedate, before the jury:
  }
  \vspace{0.5cm}
  \begin{tabular}{@{} l l}
    \@jurylist
  \end{tabular}%
}
\makeatother
```

---

## Logo setup

**Logo files are not distributed with this template** due to trademark restrictions. You must download them yourself from the official sources and place them in the `media/` directory.

The template will display a clear error message at compilation if any required logo is missing.

### Required files

| File | Description | Source |
|------|-------------|--------|
| `media/IPPARIS-petit.png` | IP Paris seal (black) | [IP Paris graphic charter](https://www.ip-paris.fr/sites/default/files/Charte%20Graphique%202025/IP-PARIS_CHARTE-GRAPHIQUE_2025.pdf) |
| `media/IPPARIS-petit-blanc.png` | IP Paris seal (white, for front cover band) | Same source |
| `media/IPPARIS-texte-blanc.png` | "INSTITUT POLYTECHNIQUE DE PARIS" text (white) | Same source |
| `media/etab/<SCHOOL>.png` | Your school logo (TSP, TP, X, ENSTA, ENSAE, or PONTS) | [Official cover template](https://www.ip-paris.fr/sites/default/files/documents-utiles/EDIPParis_modele_couverture_these.zip) or your school's communication department |
| `media/ed/edipp.png` | Doctoral school logo (for back cover) | Same cover template ZIP |

### Step by step

1. Download the [official IP Paris cover template ZIP](https://www.ip-paris.fr/sites/default/files/documents-utiles/EDIPParis_modele_couverture_these.zip)
2. Extract the logo files and place them in the corresponding `media/` subdirectories
3. For IP Paris logos not included in the ZIP, refer to the [IP Paris 2025 graphic charter](https://www.ip-paris.fr/sites/default/files/Charte%20Graphique%202025/IP-PARIS_CHARTE-GRAPHIQUE_2025.pdf) or contact your school's communication department

---

## Project structure

```
ipparis-thesis/
├── ipparis-thesis.cls      # Document class
├── main.tex                # Main document
├── bibliography.bib        # Bibliography
├── .latexmkrc              # latexmk configuration
├── front/                  # Front matter (dedication, acknowledgements, foreword)
├── chapters/               # Chapter files
├── appendices/             # Appendix files
├── figures/                # Your figures
├── tests/                  # Test suite
│   └── run_tests.py        # Automated tests (34 cases)
└── media/                  # Logos (download separately, see above)
    ├── IPPARIS-petit.png       # IP Paris seal (black, for back cover)
    ├── IPPARIS-petit-blanc.png # IP Paris seal (white, for front cover band)
    ├── IPPARIS-texte-blanc.png # "INSTITUT POLYTECHNIQUE DE PARIS" (white, centered)
    ├── etab/               # School logos
    │   └── <SCHOOL>.png    # Your school (TSP, TP, X, ENSTA, ENSAE, or PONTS)
    └── ed/                 # Doctoral school logo
        └── edipp.png       # IP Paris "Doctoral School" logo (back cover)
```

---

## Tests

The test suite compiles the template with every combination of options and checks that the right text ends up in the PDF.

**34 tests** covering:

| Tests | What is verified |
|-------|-----------------|
| 20 | Compilation for each school (TSP, TP, X, ENSTA, ENSAE) x (phd, hdr) x (english, french) |
| 2 | HDR/thesis text isolation (no cross-contamination between modes) |
| 2 | Foreword title adapts to language (Foreword / Avant-propos) |
| 2 | Acknowledgements title adapts to language |
| 1 | All metadata present in PDF (author, title, lab, NNT, jury, keywords) |
| 1 | Cotutelle option compiles |
| 4 | Custom package options (bibstyle, hyperref colors, colorlinks, combined) |
| 2 | Cover sub-command override with \renewcommand |

Run the tests:

```bash
python3 tests/run_tests.py          # all tests
python3 tests/run_tests.py -v       # verbose (shows log errors on failure)
python3 tests/run_tests.py -k hdr   # filter tests by name
python3 tests/run_tests.py -k X     # only Ecole polytechnique tests
```

Requirements for tests:
- Python 3.9+
- pdflatex (TeX Live / MiKTeX)
- pdftotext (optional, for content checks — `brew install poppler` on macOS)

---

## Requirements

- TeX Live 2022+ or MiKTeX
- XeLaTeX (recommended, for Futura Book on the cover band) or pdflatex (falls back to TeX Gyre Heros)
- biber (for bibliography)
- Futura font (included with macOS; Linux/Windows users must install separately)
- Packages: all standard, included in TeX Live full

---

## Graphic charter compliance

The front cover is generated entirely in LaTeX (no static band image). It follows the IP Paris 2025 graphic charter:

- **Logo and institution name**: the IP Paris seal and "INSTITUT POLYTECHNIQUE DE PARIS" text are extracted directly from the official institutional logo files -- exact typography, exact proportions, no approximation
- **Band text**: Futura for the document type ("These de doctorat" / "Habilitation a diriger des recherches"). Futura Medium is included with macOS. Linux/Windows users need to install Futura separately. With pdflatex, the template falls back to TeX Gyre Heros.
- **Colors**: official IP Paris color palette (blue `#1B2A4A`, red `#C1272D`, orange `#E8601C`, gray `#6D6E71`)
- **Document type**: the band text is generated dynamically based on the class options -- no need to swap image files

---

## Credits

- Front/back cover layout based on the [official IP Paris thesis cover template](https://www.ip-paris.fr/education/doctorat/ecole-doctorale-ip-paris) by Guillaume Brigot and Aurélien Arnoux (École polytechnique) ([LaTeX sources](https://www.ip-paris.fr/sites/default/files/documents-utiles/EDIPParis_modele_couverture_these.zip))
- Typography and logo usage based on the [IP Paris 2025 graphic charter](https://www.ip-paris.fr/sites/default/files/Charte%20Graphique%202025/IP-PARIS_CHARTE-GRAPHIQUE_2025.pdf)
- Thanks to [Cédric Ware](https://perso.telecom-paristech.fr/ware/index.html.fr) (Télécom Paris) for his feedback on the early versions of this template. His comments helped shape the package options system and the customizable cover pages.
- Complete template by Antoine Lavignotte (2026)

## License

CC BY 4.0

---
---

# ipparis-thesis v0.6 (Français)

**Template LaTeX pour les manuscrits de thèse et d'HDR à l'Institut Polytechnique de Paris.**

Une classe de document qui gère les couvertures officielles IP Paris, le basculement français/anglais et la sélection du logo par école, pour que vous puissiez vous concentrer sur la rédaction. Les couvertures respectent la [charte graphique IP Paris 2025](https://www.ip-paris.fr/sites/default/files/Charte%20Graphique%202025/IP-PARIS_CHARTE-GRAPHIQUE_2025.pdf) -- police Futura Book sur le bandeau, palette de couleurs conforme. **Les fichiers de logos ne sont pas inclus** pour des raisons de droit des marques -- voir [Installation des logos](#installation-des-logos) ci-dessous.

## À propos de ce projet

Ce template est né pendant la préparation de mon HDR. Je cherchais un template LaTeX pour le manuscrit et il n'y en avait pas -- IP Paris ne fournit que des fichiers Word/LaTeX pour les couvertures, rien pour le contenu.

Après avoir vu plusieurs doctorants perdre du temps sur la mise en forme dans la dernière ligne droite de leur thèse, je voulais que ça n'arrive plus. Le principe est simple : on choisit son école, on remplit ses métadonnées, et on écrit. Les couvertures, les logos et la langue se règlent tout seuls.

Les six écoles d'IP Paris partagent le même format de couverture, donc ça marche que vous soyez à Polytechnique, Télécom Paris, l'ENSTA, l'ENSAE, Télécom SudParis ou aux Ponts.

**Ce n'est pas un template officiel d'IP Paris.** C'est un projet personnel, fait pour mes doctorants. Cela dit, si ça peut servir à d'autres, tant mieux -- c'est open source et toute contribution est bienvenue.

Petit avertissement : mon poste actuel ne me laisse pas beaucoup de temps pour la maintenance. J'essaierai de répondre aux issues quand je peux, mais inutile de me mettre la pression. Une pull request sera toujours plus efficace qu'un bug report.

-- Antoine Lavignotte, 2026

---

## Démarrage rapide

```latex
\documentclass[phd]{ipparis-thesis}        % Thèse de doctorat (anglais)
\documentclass[hdr,french]{ipparis-thesis}  % HDR (français)
```

Compilation avec XeLaTeX (recommandé, pour Futura Book sur le bandeau) :

```bash
latexmk main.tex
```

Ou manuellement :

```bash
xelatex main
biber main
makeglossaries main
xelatex main
xelatex main
```

Le template compile aussi avec pdflatex, mais le bandeau utilisera TeX Gyre Heros au lieu de Futura Book, ce qui ne correspond pas aux spécifications officielles de la couverture IP Paris. XeLaTeX est fortement recommandé.

---

## Options de la classe

| Option | Description |
|--------|-------------|
| `phd` | Thèse de doctorat (par défaut) |
| `hdr` | Habilitation à diriger des recherches |
| `english` | Document en anglais (par défaut) |
| `french` | Document en français |
| `cotutelle` | Co-tutelle avec un établissement partenaire |
| `binding` | Ajoute 10mm de marge de reliure pour l'impression |
| `bibstyle=...` | Style bibliographique (défaut : `ieee`) |
| `bibsorting=...` | Tri bibliographique (défaut : `nyt`) |
| `linkcolor=...` | Couleur des liens internes (défaut : `NavyBlue`) |
| `citecolor=...` | Couleur des liens de citation (défaut : `ForestGreen`) |
| `urlcolor=...` | Couleur des liens URL (défaut : `BrickRed`) |
| `colorlinks=false` | Désactive les liens colorés (utilise des cadres) |

Les options se combinent : `\documentclass[hdr,french,bibstyle=authoryear,linkcolor=black]{ipparis-thesis}`

Pour les packages non couverts par les options ci-dessus (ex. xcolor, geometry), utiliser `\PassOptionsToPackage` avant `\documentclass` :

```latex
\PassOptionsToPackage{table}{xcolor}
\documentclass[phd,french]{ipparis-thesis}
```

---

## Choix de l'école

Utilisez la commande `\school` avec l'une des six clés :

```latex
\school{TSP}     % Télécom SudParis
\school{TP}      % Télécom Paris
\school{X}       % École polytechnique
\school{ENSTA}   % ENSTA Paris
\school{ENSAE}   % ENSAE Paris
\school{PONTS}   % École des Ponts ParisTech
```

Cette commande configure automatiquement :
- Le nom de l'établissement sur toutes les couvertures et pages de titre
- Le logo de l'école affiché à côté d'IP Paris
- Le texte "préparée à..."

Pour forcer un nom d'établissement spécifique :

```latex
\school{X}
\institution{l'École polytechnique}  % surcharge optionnelle
```

---

## Métadonnées

```latex
\author{Prénom Nom}
\titlefr{Titre en français}
\titleen{Title in English}
\school{TSP}
\lab{SAMOVAR}
\doctoralschool{626}{Institut Polytechnique de Paris}{EDIPP}
\specialty{Informatique, Données, IA}
\defensedate{15 juin 2026}
\defenseplace{Evry}
\nnt{2026IPPAXXXX}
```

---

## Jury

Les membres du jury sont ajoutés un par un. Ils apparaissent dans l'ordre sur les deux couvertures.

```latex
\jurymember{Prénom Nom}{Professeur, Université}{Rapporteur}
\jurymember{Prénom Nom}{Professeur, Université}{Rapporteur}
\jurymember{Prénom Nom}{Professeur, Université}{Examinateur}
\jurymember{Prénom Nom}{Professeur, Université}{Président}
```

---

## Résumés et mots-clés

Les deux langues sont requises (elles apparaissent en 4ème de couverture).

```latex
\abstractfr{Résumé en français...}
\abstracten{Abstract in English...}
\keywordsfr{mot1, mot2, mot3}
\keywordsen{keyword1, keyword2, keyword3}
```

---

## Structure du document

Le template génère trois pages spéciales automatiquement :

1. **`\makefrontcover`** — 1ère de couverture officielle IP Paris (bandeau noir avec logo et type de document, logo école, jury). Le bandeau est généré en LaTeX avec TikZ -- le texte s'adapte automatiquement au type de document (thèse/HDR) et à la langue (français/anglais). Le texte de la couverture est en Helvetica (sans-serif), comme dans le template officiel.
2. **`\makeinnertitle`** — Page de titre intérieure (style académique)
3. **`\makebackcover`** — 4ème de couverture officielle IP Paris (logo Doctoral School en haut, résumés bilingues, pied de page IP Paris)

Toutes les pages à partir des remerciements portent un pied de page IP Paris : "Institut Polytechnique de Paris / 91120 Palaiseau, France" à gauche, et le sceau IP Paris à droite. Le pied de page se décale avec la marge de reliure lorsque l'option `binding` est activée.

Structure type du `main.tex` :

```latex
\documentclass[hdr,french]{ipparis-thesis}

% ... métadonnées, jury, résumés ...

\addbibresource{bibliography.bib}
\makeglossaries

\begin{document}

\frontmatter
\makefrontcover

\begin{dedication}
  A ma famille.
\end{dedication}

\begin{acknowledgements}
  Je souhaite remercier...
\end{acknowledgements}

\tableofcontents
\listoffigures
\listoftables

\begin{foreword}
  Ce document présente...
\end{foreword}

\mainmatter
\include{chapters/introduction}
\include{chapters/chapitre1}
\include{chapters/chapitre2}
\include{chapters/perspectives}

\backmatter
\printbibliography[heading=bibintoc]

\appendix
\include{appendices/cv}
\include{appendices/publications}

\makebackcover

\end{document}
```

---

## Environnements fournis

| Environnement | Description |
|---------------|-------------|
| `dedication` | Page de dédicace (italique, alignée à droite) |
| `acknowledgements` | Chapitre de remerciements (titre adapté à la langue) |
| `foreword` | Avant-propos (titre adapté à la langue) |

---

## Co-tutelle

```latex
\documentclass[phd,french,cotutelle]{ipparis-thesis}
\school{TSP}
\cotutlogo{partenaire}  % placer partenaire.png dans media/etab/
```

Le logo du partenaire apparaît à gauche, le logo de l'école IP Paris à droite.

---

## Personnalisation des couvertures

Les trois pages générées (`\makefrontcover`, `\makeinnertitle`, `\makebackcover`) sont construites à partir de sous-commandes que vous pouvez redéfinir individuellement avec `\renewcommand`. Cela permet de modifier une section spécifique sans réécrire la page entière.

### Sous-commandes disponibles

**1ère de couverture** (`\makefrontcover`) :

| Commande | Ce qu'elle affiche |
|----------|-------------------|
| `\frontcoverband` | Bandeau noir avec logo IP Paris, NNT et type de document |
| `\frontcoverlogos` | Logos des écoles (partenaire co-tutelle + école principale) |
| `\frontcovercontent` | Bloc texte (titre, établissement, école doctorale, auteur) |
| `\frontcoverjury` | Tableau du jury |

**Page de titre intérieure** (`\makeinnertitle`) :

| Commande | Ce qu'elle affiche |
|----------|-------------------|
| `\innertitlelogos` | Logo ED (gauche) + logos école et IP Paris (droite) |
| `\innertitleheader` | Type de document, spécialité, auteur, établissement |
| `\innertitlebody` | Titre entre filets horizontaux |
| `\innertitlejury` | Date de soutenance et tableau du jury |

**4ème de couverture** (`\makebackcover`) :

| Commande | Ce qu'elle affiche |
|----------|-------------------|
| `\backcoverfrench` | Bloc résumé français (titre, mots-clés, résumé) |
| `\backcoverenglish` | Bloc résumé anglais |
| `\backcoverfooter` | Nom et logo IP Paris en bas de page |

### Exemple : jury personnalisé sur la page de titre intérieure

```latex
\makeatletter
\renewcommand{\innertitlejury}{%
  {\small
    soutenue le \@defensedate, devant le jury :
  }
  \vspace{0.5cm}
  \begin{tabular}{@{} l l}
    \@jurylist
  \end{tabular}%
}
\makeatother
```

---

## Installation des logos

**Les fichiers de logos ne sont pas distribués avec ce template** pour des raisons de droit des marques. Vous devez les télécharger vous-même depuis les sources officielles et les placer dans le dossier `media/`.

Le template affichera un message d'erreur clair à la compilation si un logo requis est manquant.

### Fichiers requis

| Fichier | Description | Source |
|---------|-------------|--------|
| `media/IPPARIS-petit.png` | Sceau IP Paris (noir) | [Charte graphique IP Paris](https://www.ip-paris.fr/sites/default/files/Charte%20Graphique%202025/IP-PARIS_CHARTE-GRAPHIQUE_2025.pdf) |
| `media/IPPARIS-petit-blanc.png` | Sceau IP Paris (blanc, pour le bandeau) | Même source |
| `media/IPPARIS-texte-blanc.png` | Texte "INSTITUT POLYTECHNIQUE DE PARIS" (blanc) | Même source |
| `media/etab/<ECOLE>.png` | Logo de votre école (TSP, TP, X, ENSTA, ENSAE ou PONTS) | [Modèle officiel de couverture](https://www.ip-paris.fr/sites/default/files/documents-utiles/EDIPParis_modele_couverture_these.zip) ou service communication de votre école |
| `media/ed/edipp.png` | Logo école doctorale (4ème de couverture) | Même ZIP du modèle de couverture |

### Étape par étape

1. Télécharger le [ZIP du modèle officiel de couverture IP Paris](https://www.ip-paris.fr/sites/default/files/documents-utiles/EDIPParis_modele_couverture_these.zip)
2. Extraire les fichiers de logos et les placer dans les sous-dossiers correspondants de `media/`
3. Pour les logos IP Paris non inclus dans le ZIP, se référer à la [charte graphique IP Paris 2025](https://www.ip-paris.fr/sites/default/files/Charte%20Graphique%202025/IP-PARIS_CHARTE-GRAPHIQUE_2025.pdf) ou contacter le service communication de votre école

---

## Structure du projet

```
ipparis-thesis/
├── ipparis-thesis.cls      # Classe LaTeX
├── main.tex                # Document principal
├── bibliography.bib        # Bibliographie
├── .latexmkrc              # Configuration latexmk
├── front/                  # Front matter (dédicace, remerciements, avant-propos)
├── chapters/               # Fichiers de chapitres
├── appendices/             # Fichiers d'annexes
├── figures/                # Vos figures
├── tests/                  # Suite de tests
│   └── run_tests.py        # Tests automatisés (34 cas)
└── media/                      # Logos (à télécharger, voir ci-dessus)
    ├── IPPARIS-petit.png       # Sceau IP Paris (noir, pour 4ème de couverture)
    ├── IPPARIS-petit-blanc.png # Sceau IP Paris (blanc, pour bandeau 1ère de couverture)
    ├── IPPARIS-texte-blanc.png # "INSTITUT POLYTECHNIQUE DE PARIS" (blanc, centré)
    ├── etab/               # Logos des écoles
    │   └── <ECOLE>.png     # Votre école (TSP, TP, X, ENSTA, ENSAE ou PONTS)
    └── ed/                 # Logo école doctorale
        └── edipp.png       # Logo "Doctoral School" IP Paris (4ème de couverture)
```

---

## Tests

La suite de tests compile le template avec toutes les combinaisons d'options et vérifie que le bon texte se retrouve dans le PDF.

**34 tests** couvrant :

| Tests | Ce qui est vérifié |
|-------|--------------------|
| 20 | Compilation pour chaque école (TSP, TP, X, ENSTA, ENSAE) x (phd, hdr) x (english, french) |
| 2 | Isolation des textes HDR/thèse (pas de contamination croisée entre les modes) |
| 2 | Le titre de l'avant-propos s'adapte à la langue (Foreword / Avant-propos) |
| 2 | Le titre des remerciements s'adapte à la langue |
| 1 | Toutes les métadonnées présentes dans le PDF (auteur, titre, labo, NNT, jury, mots-clés) |
| 1 | L'option cotutelle compile |
| 4 | Options personnalisées de packages (bibstyle, couleurs hyperref, colorlinks, combinées) |
| 2 | Surcharge de sous-commandes de couverture avec \renewcommand |

Lancer les tests :

```bash
python3 tests/run_tests.py          # tous les tests
python3 tests/run_tests.py -v       # mode verbose (affiche les erreurs du log en cas d'échec)
python3 tests/run_tests.py -k hdr   # filtrer les tests par nom
python3 tests/run_tests.py -k X     # uniquement les tests École polytechnique
```

Prérequis pour les tests :
- Python 3.9+
- pdflatex (TeX Live / MiKTeX)
- pdftotext (optionnel, pour les vérifications de contenu — `brew install poppler` sur macOS)

---

## Prérequis

- TeX Live 2022+ ou MiKTeX
- XeLaTeX (recommandé, pour Futura Book sur le bandeau de couverture) ou pdflatex (utilise TeX Gyre Heros en remplacement)
- biber (pour la bibliographie)
- Police Futura (incluse avec macOS ; les utilisateurs Linux/Windows doivent l'installer séparément)
- Packages : tous standards, inclus dans TeX Live full

---

## Conformité à la charte graphique

La 1ère de couverture est générée entièrement en LaTeX (pas d'image statique pour le bandeau). Elle respecte la charte graphique IP Paris 2025 :

- **Logo et nom de l'institution** : le sceau IP Paris et le texte "INSTITUT POLYTECHNIQUE DE PARIS" sont extraits directement des fichiers logo institutionnels -- typographie exacte, proportions exactes, aucune approximation
- **Texte du bandeau** : Futura pour le type de document ("Thèse de doctorat" / "Habilitation à diriger des recherches"). Futura Medium est incluse avec macOS. Les utilisateurs Linux/Windows doivent installer Futura séparément. Avec pdflatex, le template utilise TeX Gyre Heros en remplacement.
- **Couleurs** : palette officielle IP Paris (bleu `#1B2A4A`, rouge `#C1272D`, orange `#E8601C`, gris `#6D6E71`)
- **Type de document** : le texte du bandeau est généré dynamiquement selon les options de la classe -- pas besoin de changer d'image

---

## Crédits

- Mise en page des couvertures basée sur le [modèle officiel IP Paris pour les couvertures de thèse](https://www.ip-paris.fr/education/doctorat/ecole-doctorale-ip-paris) par Guillaume Brigot et Aurélien Arnoux (École polytechnique) ([sources LaTeX](https://www.ip-paris.fr/sites/default/files/documents-utiles/EDIPParis_modele_couverture_these.zip))
- Typographie et usage du logo basés sur la [charte graphique IP Paris 2025](https://www.ip-paris.fr/sites/default/files/Charte%20Graphique%202025/IP-PARIS_CHARTE-GRAPHIQUE_2025.pdf)
- Merci à [Cédric Ware](https://perso.telecom-paristech.fr/ware/index.html.fr) (Télécom Paris) pour ses retours sur les premières versions du template. Ses commentaires ont permis d'améliorer le système d'options et la personnalisation des couvertures.
- Template complet par Antoine Lavignotte (2026)

## Licence

CC BY 4.0
