# ipparis-thesis v0.1

**LaTeX template for thesis and HDR manuscripts at Institut Polytechnique de Paris.**

A document class that handles official IP Paris covers, French/English switching, and per-school logo selection so you can get on with writing. The covers follow the [IP Paris 2025 graphic charter](https://www.ip-paris.fr/sites/default/files/Charte%20Graphique%202025/IP-PARIS_CHARTE-GRAPHIQUE_2025.pdf) -- official logos, Futura Book typeface on the band, correct color palette.

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

Options can be combined: `\documentclass[hdr,french,cotutelle,binding]{ipparis-thesis}`

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

## Project structure

```
ipparis-thesis/
├── ipparis-thesis.cls      # Document class
├── main.tex                # Main document
├── bibliography.bib        # Bibliography
├── .latexmkrc              # latexmk configuration
├── chapters/               # Chapter files
├── appendices/             # Appendix files
├── figures/                # Your figures
├── tests/                  # Test suite
│   └── run_tests.py        # Automated tests (28 cases)
└── media/                  # Logos (do not modify)
    ├── IPPARIS-petit.png       # IP Paris seal (black, for back cover)
    ├── IPPARIS-petit-blanc.png # IP Paris seal (white, for front cover band)
    ├── IPPARIS-texte-blanc.png # "INSTITUT POLYTECHNIQUE DE PARIS" (white, centered)
    ├── etab/               # School logos
    │   ├── TSP.png         # Telecom SudParis
    │   ├── TP.png          # Telecom Paris
    │   ├── X.png           # Ecole polytechnique
    │   ├── ENSTA.png       # ENSTA Paris
    │   └── ENSAE.png       # ENSAE Paris
    └── ed/                 # Doctoral school logo
        └── edipp.png       # IP Paris "Doctoral School" logo (back cover)
```

---

## Tests

The test suite compiles the template with every combination of options and checks that the right text ends up in the PDF.

**28 tests** covering:

| Tests | What is verified |
|-------|-----------------|
| 20 | Compilation for each school (TSP, TP, X, ENSTA, ENSAE) x (phd, hdr) x (english, french) |
| 2 | HDR/thesis text isolation (no cross-contamination between modes) |
| 2 | Foreword title adapts to language (Foreword / Avant-propos) |
| 2 | Acknowledgements title adapts to language |
| 1 | All metadata present in PDF (author, title, lab, NNT, jury, keywords) |
| 1 | Cotutelle option compiles |

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

- Front/back cover layout based on the official IP Paris thesis cover template by Guillaume Brigot and Aurelien Arnoux (Ecole polytechnique)
- Typography and logo usage based on the [IP Paris 2025 graphic charter](https://www.ip-paris.fr/sites/default/files/Charte%20Graphique%202025/IP-PARIS_CHARTE-GRAPHIQUE_2025.pdf)
- Complete template by Antoine Lavignotte (2026)

## License

CC BY 4.0

---
---

# ipparis-thesis v0.1 (Francais)

**Template LaTeX pour les manuscrits de these et d'HDR a l'Institut Polytechnique de Paris.**

Une classe de document qui gere les couvertures officielles IP Paris, le basculement francais/anglais et la selection du logo par ecole, pour que vous puissiez vous concentrer sur la redaction. Les couvertures respectent la [charte graphique IP Paris 2025](https://www.ip-paris.fr/sites/default/files/Charte%20Graphique%202025/IP-PARIS_CHARTE-GRAPHIQUE_2025.pdf) -- logos officiels, police Futura Book sur le bandeau, palette de couleurs conforme.

## A propos de ce projet

Ce template est ne pendant la preparation de mon HDR. Je cherchais un template LaTeX pour le manuscrit et il n'y en avait pas -- IP Paris ne fournit que des fichiers Word/LaTeX pour les couvertures, rien pour le contenu.

Apres avoir vu plusieurs doctorants perdre du temps sur la mise en forme dans la derniere ligne droite de leur these, je voulais que ca n'arrive plus. Le principe est simple : on choisit son ecole, on remplit ses metadonnees, et on ecrit. Les couvertures, les logos et la langue se reglent tout seuls.

Les six ecoles d'IP Paris partagent le meme format de couverture, donc ca marche que vous soyez a Polytechnique, Telecom Paris, l'ENSTA, l'ENSAE, Telecom SudParis ou aux Ponts.

**Ce n'est pas un template officiel d'IP Paris.** C'est un projet personnel, fait pour mes doctorants. Cela dit, si ca peut servir a d'autres, tant mieux -- c'est open source et toute contribution est bienvenue.

Petit avertissement : mon poste actuel ne me laisse pas beaucoup de temps pour la maintenance. J'essaierai de repondre aux issues quand je peux, mais inutile de me mettre la pression. Une pull request sera toujours plus efficace qu'un bug report.

-- Antoine Lavignotte, 2026

---

## Demarrage rapide

```latex
\documentclass[phd]{ipparis-thesis}        % These de doctorat (anglais)
\documentclass[hdr,french]{ipparis-thesis}  % HDR (francais)
```

Compilation avec XeLaTeX (recommande, pour Futura Book sur le bandeau) :

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

Le template compile aussi avec pdflatex, mais le bandeau utilisera TeX Gyre Heros au lieu de Futura Book, ce qui ne correspond pas aux specifications officielles de la couverture IP Paris. XeLaTeX est fortement recommande.

---

## Options de la classe

| Option | Description |
|--------|-------------|
| `phd` | These de doctorat (par defaut) |
| `hdr` | Habilitation a diriger des recherches |
| `english` | Document en anglais (par defaut) |
| `french` | Document en francais |
| `cotutelle` | Co-tutelle avec un etablissement partenaire |
| `binding` | Ajoute 10mm de marge de reliure pour l'impression |

Les options se combinent : `\documentclass[hdr,french,cotutelle,binding]{ipparis-thesis}`

---

## Choix de l'ecole

Utilisez la commande `\school` avec l'une des six cles :

```latex
\school{TSP}     % Telecom SudParis
\school{TP}      % Telecom Paris
\school{X}       % Ecole polytechnique
\school{ENSTA}   % ENSTA Paris
\school{ENSAE}   % ENSAE Paris
\school{PONTS}   % Ecole des Ponts ParisTech
```

Cette commande configure automatiquement :
- Le nom de l'etablissement sur toutes les couvertures et pages de titre
- Le logo de l'ecole affiche a cote d'IP Paris
- Le texte "preparee a..."

Pour forcer un nom d'etablissement specifique :

```latex
\school{X}
\institution{l'Ecole polytechnique}  % surcharge optionnelle
```

---

## Metadonnees

```latex
\author{Prenom Nom}
\titlefr{Titre en francais}
\titleen{Title in English}
\school{TSP}
\lab{SAMOVAR}
\doctoralschool{626}{Institut Polytechnique de Paris}{EDIPP}
\specialty{Informatique, Donnees, IA}
\defensedate{15 juin 2026}
\defenseplace{Evry}
\nnt{2026IPPAXXXX}
```

---

## Jury

Les membres du jury sont ajoutes un par un. Ils apparaissent dans l'ordre sur les deux couvertures.

```latex
\jurymember{Prenom Nom}{Professeur, Universite}{Rapporteur}
\jurymember{Prenom Nom}{Professeur, Universite}{Rapporteur}
\jurymember{Prenom Nom}{Professeur, Universite}{Examinateur}
\jurymember{Prenom Nom}{Professeur, Universite}{President}
```

---

## Resumes et mots-cles

Les deux langues sont requises (elles apparaissent en 4eme de couverture).

```latex
\abstractfr{Resume en francais...}
\abstracten{Abstract in English...}
\keywordsfr{mot1, mot2, mot3}
\keywordsen{keyword1, keyword2, keyword3}
```

---

## Structure du document

Le template genere trois pages speciales automatiquement :

1. **`\makefrontcover`** — 1ere de couverture officielle IP Paris (bandeau noir avec logo et type de document, logo ecole, jury). Le bandeau est genere en LaTeX avec TikZ -- le texte s'adapte automatiquement au type de document (these/HDR) et a la langue (francais/anglais). Le texte de la couverture est en Helvetica (sans-serif), comme dans le template officiel.
2. **`\makeinnertitle`** — Page de titre interieure (style academique)
3. **`\makebackcover`** — 4eme de couverture officielle IP Paris (logo Doctoral School en haut, resumes bilingues, pied de page IP Paris)

Toutes les pages a partir des remerciements portent un pied de page IP Paris : "Institut Polytechnique de Paris / 91120 Palaiseau, France" a gauche, et le sceau IP Paris a droite. Le pied de page se decale avec la marge de reliure lorsque l'option `binding` est activee.

Structure type du `main.tex` :

```latex
\documentclass[hdr,french]{ipparis-thesis}

% ... metadonnees, jury, resumes ...

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
  Ce document presente...
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
| `dedication` | Page de dedicace (italique, alignee a droite) |
| `acknowledgements` | Chapitre de remerciements (titre adapte a la langue) |
| `foreword` | Avant-propos (titre adapte a la langue) |

---

## Co-tutelle

```latex
\documentclass[phd,french,cotutelle]{ipparis-thesis}
\school{TSP}
\cotutlogo{partenaire}  % placer partenaire.png dans media/etab/
```

Le logo du partenaire apparait a gauche, le logo de l'ecole IP Paris a droite.

---

## Structure du projet

```
ipparis-thesis/
├── ipparis-thesis.cls      # Classe LaTeX
├── main.tex                # Document principal
├── bibliography.bib        # Bibliographie
├── .latexmkrc              # Configuration latexmk
├── chapters/               # Fichiers de chapitres
├── appendices/             # Fichiers d'annexes
├── figures/                # Vos figures
├── tests/                  # Suite de tests
│   └── run_tests.py        # Tests automatises (28 cas)
└── media/                      # Logos (ne pas modifier)
    ├── IPPARIS-petit.png       # Sceau IP Paris (noir, pour 4eme de couverture)
    ├── IPPARIS-petit-blanc.png # Sceau IP Paris (blanc, pour bandeau 1ere de couverture)
    ├── IPPARIS-texte-blanc.png # "INSTITUT POLYTECHNIQUE DE PARIS" (blanc, centre)
    ├── etab/               # Logos des ecoles
    │   ├── TSP.png         # Telecom SudParis
    │   ├── TP.png          # Telecom Paris
    │   ├── X.png           # Ecole polytechnique
    │   ├── ENSTA.png       # ENSTA Paris
    │   └── ENSAE.png       # ENSAE Paris
    └── ed/                 # Logo ecole doctorale
        └── edipp.png       # Logo "Doctoral School" IP Paris (4eme de couverture)
```

---

## Tests

La suite de tests compile le template avec toutes les combinaisons d'options et verifie que le bon texte se retrouve dans le PDF.

**28 tests** couvrant :

| Tests | Ce qui est verifie |
|-------|--------------------|
| 20 | Compilation pour chaque ecole (TSP, TP, X, ENSTA, ENSAE) x (phd, hdr) x (english, french) |
| 2 | Isolation des textes HDR/these (pas de contamination croisee entre les modes) |
| 2 | Le titre de l'avant-propos s'adapte a la langue (Foreword / Avant-propos) |
| 2 | Le titre des remerciements s'adapte a la langue |
| 1 | Toutes les metadonnees presentes dans le PDF (auteur, titre, labo, NNT, jury, mots-cles) |
| 1 | L'option cotutelle compile |

Lancer les tests :

```bash
python3 tests/run_tests.py          # tous les tests
python3 tests/run_tests.py -v       # mode verbose (affiche les erreurs du log en cas d'echec)
python3 tests/run_tests.py -k hdr   # filtrer les tests par nom
python3 tests/run_tests.py -k X     # uniquement les tests Ecole polytechnique
```

Prerequis pour les tests :
- Python 3.9+
- pdflatex (TeX Live / MiKTeX)
- pdftotext (optionnel, pour les verifications de contenu — `brew install poppler` sur macOS)

---

## Prerequis

- TeX Live 2022+ ou MiKTeX
- XeLaTeX (recommande, pour Futura Book sur le bandeau de couverture) ou pdflatex (utilise TeX Gyre Heros en remplacement)
- biber (pour la bibliographie)
- Police Futura (incluse avec macOS ; les utilisateurs Linux/Windows doivent l'installer separement)
- Packages : tous standards, inclus dans TeX Live full

---

## Conformite a la charte graphique

La 1ere de couverture est generee entierement en LaTeX (pas d'image statique pour le bandeau). Elle respecte la charte graphique IP Paris 2025 :

- **Logo et nom de l'institution** : le sceau IP Paris et le texte "INSTITUT POLYTECHNIQUE DE PARIS" sont extraits directement des fichiers logo institutionnels -- typographie exacte, proportions exactes, aucune approximation
- **Texte du bandeau** : Futura pour le type de document ("These de doctorat" / "Habilitation a diriger des recherches"). Futura Medium est incluse avec macOS. Les utilisateurs Linux/Windows doivent installer Futura separement. Avec pdflatex, le template utilise TeX Gyre Heros en remplacement.
- **Couleurs** : palette officielle IP Paris (bleu `#1B2A4A`, rouge `#C1272D`, orange `#E8601C`, gris `#6D6E71`)
- **Type de document** : le texte du bandeau est genere dynamiquement selon les options de la classe -- pas besoin de changer d'image

---

## Credits

- Mise en page des couvertures basee sur le modele officiel IP Paris pour les couvertures de these par Guillaume Brigot et Aurelien Arnoux (Ecole polytechnique)
- Typographie et usage du logo bases sur la [charte graphique IP Paris 2025](https://www.ip-paris.fr/sites/default/files/Charte%20Graphique%202025/IP-PARIS_CHARTE-GRAPHIQUE_2025.pdf)
- Template complet par Antoine Lavignotte (2026)

## Licence

CC BY 4.0
