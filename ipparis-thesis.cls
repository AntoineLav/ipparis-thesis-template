%%
%% ipparis-thesis.cls — LaTeX class for thesis and HDR manuscripts
%% at Institut Polytechnique de Paris
%%
%% Integrates official IP Paris front/back covers with a complete
%% book-class manuscript template.
%%
%% Usage: \documentclass[hdr]{ipparis-thesis}
%%    or: \documentclass[phd]{ipparis-thesis}
%%
%% 2026 — Antoine Lavignotte
%% Released under CC BY 4.0
%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ipparis-thesis}[2026/03/28 v0.6 IP Paris Thesis/HDR Template]

%% ── Options ──────────────────────────────────────────────────────

\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=ipparis,prefix=ipparis@}

% Document type and language (boolean flags)
\newif\if@hdr\@hdrfalse
\newif\if@phd\@phdtrue
\newif\if@french\@frenchfalse
\newif\if@cotutelle\@cotutellefalse
\newif\if@binding\@bindingfalse

\DeclareVoidOption{hdr}{\@hdrtrue\@phdfalse}
\DeclareVoidOption{phd}{\@phdtrue\@hdrfalse}
\DeclareVoidOption{english}{\@frenchfalse}
\DeclareVoidOption{french}{\@frenchtrue}
\DeclareVoidOption{cotutelle}{\@cotutelletrue}
\DeclareVoidOption{binding}{\@bindingtrue}

% Customizable package options (key=value)
\DeclareStringOption[ieee]{bibstyle}
\DeclareStringOption[nyt]{bibsorting}
\DeclareStringOption[NavyBlue]{linkcolor}
\DeclareStringOption[ForestGreen]{citecolor}
\DeclareStringOption[BrickRed]{urlcolor}
\DeclareBoolOption[true]{colorlinks}

% Unknown options go to book class
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{book}}

\ProcessKeyvalOptions*\relax

%% ── Base class ───────────────────────────────────────────────────

\LoadClass[a4paper,11pt,twoside,openright]{book}

%% ── Required packages ────────────────────────────────────────────

\RequirePackage{iftex}
\ifPDFTeX
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[T1]{fontenc}
  \RequirePackage{lmodern}
\else
  \RequirePackage{fontspec}
  \defaultfontfeatures{Ligatures=TeX}
  \RequirePackage{lmodern}
  \newfontfamily\bandfont{Futura-Medium}
\fi
\RequirePackage{microtype}

% Geometry
\RequirePackage[
  left=25mm,
  right=25mm,
  top=30mm,
  bottom=25mm,
  headheight=14pt,
  footskip=15mm,
  \if@binding bindingoffset=10mm,\fi
]{geometry}

% Language
\if@french
  \RequirePackage[english,french]{babel}
\else
  \RequirePackage[french,english]{babel}
\fi

% Graphics & colors
\RequirePackage{graphicx}
\RequirePackage[dvipsnames,svgnames]{xcolor}
\RequirePackage[absolute,overlay]{textpos}
\RequirePackage{tikz}

% Typography
\RequirePackage{setspace}
\onehalfspacing

% Headers/footers
\RequirePackage{fancyhdr}
\RequirePackage{emptypage}

% TOC, lists
\RequirePackage[titles]{tocloft}
\RequirePackage{enumitem}

% Math
\RequirePackage{amsmath,amssymb,amsthm}

% Tables & figures
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{float}
\RequirePackage[font=small,labelfont=bf]{caption}
\RequirePackage{subcaption}

% Bibliography
\RequirePackage[
  backend=biber,
  style=\ipparis@bibstyle,
  sorting=\ipparis@bibsorting,
  maxbibnames=99,
]{biblatex}

% Hyperlinks (load last among these)
\ifipparis@colorlinks
  \PassOptionsToPackage{colorlinks=true}{hyperref}%
\else
  \PassOptionsToPackage{colorlinks=false}{hyperref}%
\fi
\RequirePackage[
  linkcolor=\ipparis@linkcolor,
  citecolor=\ipparis@citecolor,
  urlcolor=\ipparis@urlcolor,
  pdfusetitle,
]{hyperref}
\RequirePackage{bookmark}

% Algorithms, listings (optional, loaded but available)
\RequirePackage{algorithm}
\RequirePackage{algpseudocode}
\RequirePackage{listings}

%% ── Logo file checks ───────────────────────────────────────────
%% Logos are not distributed with this template (trademark restrictions).
%% See README.md for download instructions.

\newcommand{\@checklogofile}[2]{%
  \IfFileExists{#1}{}{%
    \ClassError{ipparis-thesis}{%
      Missing logo file: #1\MessageBreak
      #2\MessageBreak
      See README.md for download instructions%
    }{%
      Logo files are not distributed with this template due to
      trademark restrictions.\MessageBreak
      Download them from the official sources listed in README.md
      and place them\MessageBreak in the media/ directory.%
    }%
  }%
}


% Glossary / acronyms
\RequirePackage[acronym,toc]{glossaries}

%% ── IP Paris colors ──────────────────────────────────────────────
%% From the 2025 graphic charter

\definecolor{ipparis-blue}{HTML}{1B2A4A}
\definecolor{ipparis-red}{HTML}{C1272D}
\definecolor{ipparis-orange}{HTML}{E8601C}
\definecolor{ipparis-gray}{HTML}{6D6E71}

%% ── Metadata commands ────────────────────────────────────────────

% Author
\newcommand{\@authorname}{Prénom Nom}
\renewcommand{\author}[1]{\renewcommand{\@authorname}{#1}}

% Title (French + English)
\newcommand{\@titlefr}{Titre en français}
\newcommand{\@titleen}{Title in English}
\newcommand{\titlefr}[1]{\renewcommand{\@titlefr}{#1}}
\newcommand{\titleen}[1]{\renewcommand{\@titleen}{#1}}

% Convenience: \title sets French title
\renewcommand{\title}[1]{\titlefr{#1}}

% Doctoral school
\newcommand{\@edname}{Dénomination}
\newcommand{\@edacronym}{Sigle}
\newcommand{\@ednum}{000}
\newcommand{\doctoralschool}[3]{%
  \renewcommand{\@ednum}{#1}%
  \renewcommand{\@edname}{#2}%
  \renewcommand{\@edacronym}{#3}%
}

% Specialty
\newcommand{\@specialty}{Spécialité}
\newcommand{\specialty}[1]{\renewcommand{\@specialty}{#1}}

% School — sets institution name and logo automatically
% Valid keys: TSP, TP, X, ENSTA, ENSAE, PONTS
\newcommand{\@instlogo}{TSP}
\newcommand{\@institution}{Télécom SudParis}
\newcommand{\school}[1]{%
  \renewcommand{\@instlogo}{#1}%
  \ifnum\pdfstrcmp{#1}{TSP}=0
    \renewcommand{\@institution}{Télécom SudParis}%
  \else\ifnum\pdfstrcmp{#1}{TP}=0
    \renewcommand{\@institution}{Télécom Paris}%
  \else\ifnum\pdfstrcmp{#1}{X}=0
    \renewcommand{\@institution}{l'École polytechnique}%
  \else\ifnum\pdfstrcmp{#1}{ENSTA}=0
    \renewcommand{\@institution}{l'ENSTA Paris}%
  \else\ifnum\pdfstrcmp{#1}{ENSAE}=0
    \renewcommand{\@institution}{l'ENSAE Paris}%
  \else\ifnum\pdfstrcmp{#1}{PONTS}=0
    \renewcommand{\@institution}{l'École des Ponts ParisTech}%
  \fi\fi\fi\fi\fi\fi
}

% Override institution name if needed (optional)
\newcommand{\institution}[1]{\renewcommand{\@institution}{#1}}

% Co-tutelle partner institution (optional)
\newcommand{\@cotutlogo}{blank}
\newcommand{\cotutlogo}[1]{\renewcommand{\@cotutlogo}{#1}}

% Laboratory
\newcommand{\@lab}{Laboratoire}
\newcommand{\lab}[1]{\renewcommand{\@lab}{#1}}

% Doctoral school logo file (relative to media/ed/, default: edipp.png)
\newcommand{\@edlogo}{edipp.png}
\newcommand{\edlogo}[1]{\renewcommand{\@edlogo}{#1}}

% Defense
\newcommand{\@defensedate}{Date}
\newcommand{\@defenseplace}{Palaiseau}
\newcommand{\defensedate}[1]{\renewcommand{\@defensedate}{#1}}
\newcommand{\defenseplace}[1]{\renewcommand{\@defenseplace}{#1}}

% NNT (national thesis number)
\newcommand{\@nnt}{20XXIPPAXXXX}
\newcommand{\nnt}[1]{\renewcommand{\@nnt}{#1}}

% Abstract
\newcommand{\@abstractfr}{}
\newcommand{\@abstracten}{}
\newcommand{\abstractfr}[1]{\renewcommand{\@abstractfr}{#1}}
\newcommand{\abstracten}[1]{\renewcommand{\@abstracten}{#1}}

% Keywords
\newcommand{\@keywordsfr}{}
\newcommand{\@keywordsen}{}
\newcommand{\keywordsfr}[1]{\renewcommand{\@keywordsfr}{#1}}
\newcommand{\keywordsen}[1]{\renewcommand{\@keywordsen}{#1}}

%% ── Jury ─────────────────────────────────────────────────────────

\newcommand{\@jurylist}{}
\newcommand{\jurymember}[3]{%
  % #1: Name, #2: Affiliation, #3: Role
  % Official IP Paris format: name \\ affiliation on left, role on right
  \g@addto@macro\@jurylist{%
    #1 \\ #2 & #3 \\[5pt]%
  }%
}

%% ── Page styles ──────────────────────────────────────────────────

% IP Paris footer: institution name + logo (absolute, binding-aware)
\newcommand{\@bindingshift}{0mm}
\if@binding
  \renewcommand{\@bindingshift}{10mm}
\fi
\newcommand{\@ipparisfooter}{%
  \begin{tikzpicture}[remember picture,overlay]
    \ifodd\value{page}%
      % Odd page (recto): binding on left
      \node[anchor=south west,inner sep=0pt]
        at ([xshift=16mm+\@bindingshift,yshift=8mm]current page.south west)
        {\parbox{80mm}{\footnotesize\bfseries Institut Polytechnique de Paris\\[-1pt]
         \fontseries{m}\selectfont 91120 Palaiseau, France}};
      \node[anchor=south east,inner sep=0pt]
        at ([xshift=-16mm,yshift=8mm]current page.south east)
        {\includegraphics[width=14mm]{media/IPPARIS-petit}};
    \else%
      % Even page (verso): binding on right
      \node[anchor=south west,inner sep=0pt]
        at ([xshift=16mm,yshift=8mm]current page.south west)
        {\parbox{80mm}{\footnotesize\bfseries Institut Polytechnique de Paris\\[-1pt]
         \fontseries{m}\selectfont 91120 Palaiseau, France}};
      \node[anchor=south east,inner sep=0pt]
        at ([xshift=-16mm-\@bindingshift,yshift=8mm]current page.south east)
        {\includegraphics[width=14mm]{media/IPPARIS-petit}};
    \fi
  \end{tikzpicture}%
}

\fancypagestyle{main}{%
  \fancyhf{}%
  \fancyhead[LE]{\small\nouppercase{\leftmark}}%
  \fancyhead[RO]{\small\nouppercase{\rightmark}}%
  \fancyfoot[L]{\@ipparisfooter}%
  \renewcommand{\headrulewidth}{0.4pt}%
  \renewcommand{\footrulewidth}{0pt}%
}

\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyfoot[L]{\@ipparisfooter}%
  \renewcommand{\headrulewidth}{0pt}%
}

%% ── Chapter heading style ────────────────────────────────────────

\RequirePackage{titlesec}

\titleformat{\chapter}[display]
  {\normalfont\huge\bfseries}
  {\chaptertitlename\ \thechapter}
  {20pt}
  {\Huge}

\titleformat{name=\chapter,numberless}[display]
  {\normalfont\huge\bfseries}
  {}
  {0pt}
  {\Huge}

%% ── Front cover ──────────────────────────────────────────────────
%% Each sub-command can be individually overridden with \renewcommand.

% Black band with IP Paris logo, NNT, and document type
\newcommand{\frontcoverband}{%
  \begin{tikzpicture}[remember picture,overlay]
    \fill[black] (current page.north west) rectangle
      ([xshift=57mm]current page.south west);
    \node[inner sep=0pt]
      at ([xshift=28mm,yshift=-20mm]current page.north west)
      {\includegraphics[width=21mm]{media/IPPARIS-petit-blanc.png}};
    \node[anchor=north,inner sep=0pt]
      at ([xshift=28mm,yshift=-35mm]current page.north west)
      {\includegraphics[width=40mm]{media/IPPARIS-texte-blanc.png}};
    \node[anchor=south west,inner sep=0pt]
      at ([xshift=5mm,yshift=-115mm]current page.north west)
      {\rotatebox{90}{\color{white}\bfseries\Large NNT : \@nnt}};
    \node[anchor=south west,inner sep=0pt]
      at ([xshift=10mm,yshift=-290mm]current page.north west)
      {\rotatebox{90}{\color{white}%
        \ifPDFTeX\fontfamily{qhv}\selectfont\bfseries\else\bandfont\fi
        \if@hdr\fontsize{34}{40}\else\fontsize{42}{48}\fi\selectfont
        \if@hdr
          \if@french Habilitation \`a diriger des recherches%
          \else Habilitation to Supervise Research\fi
        \else
          \if@french Th\`ese de doctorat%
          \else Doctoral Thesis\fi
        \fi}};
  \end{tikzpicture}%
}

% School logos on front cover (cotutelle partner + main school)
\newcommand{\frontcoverlogos}{%
  \if@cotutelle
    \begin{textblock}{1}(6.1,0.1)
      \textblockcolour{white}
      \includegraphics[scale=1]{media/etab/\@cotutlogo.png}
    \end{textblock}
  \fi
  \begin{textblock}{1}(12.25,0.1)
    \textblockcolour{white}
    \includegraphics[scale=1]{media/etab/\@instlogo.png}
  \end{textblock}%
}

% Front cover text content (title, institution, doctoral school, author)
\newcommand{\frontcovercontent}{%
  \begin{textblock}{10}(5.7,3)
    \textblockcolour{white}
    \sffamily
    \color{black}
    \begin{flushright}
      \huge{\if@french\@titlefr\else\@titleen\fi} \bigskip
      \vfill
      \color{black}
      \normalsize{%
        \if@hdr
          \if@french Habilitation à diriger des recherches de l'Institut Polytechnique de Paris%
          \else Habilitation to Supervise Research of Institut Polytechnique de Paris\fi
        \else
          \if@french Thèse de doctorat de l'Institut Polytechnique de Paris%
          \else Doctoral Thesis of Institut Polytechnique de Paris\fi
        \fi
      } \\
      \if@french préparée à\else prepared at\fi{} \@institution \\ \bigskip
      \vfill
      \if@french École doctorale\else Doctoral School\fi{} n$^{\circ}$\@ednum~\@edname~(\@edacronym) \\

      \small{\if@french Spécialité de doctorat\else Doctoral specialty\fi{} : \@specialty} \bigskip
      \vfill
      \footnotesize{%
        \if@hdr
          \if@french Habilitation présentée et soutenue à \@defenseplace, le \@defensedate, par%
          \else Habilitation presented and defended at \@defenseplace, on \@defensedate, by\fi
        \else
          \if@french Thèse présentée et soutenue à \@defenseplace, le \@defensedate, par%
          \else Thesis presented and defended at \@defenseplace, on \@defensedate, by\fi
        \fi
      } \bigskip
      \vfill
      \Large{\textbf{\textsc{\@authorname}}}
      \vfill
    \end{flushright}

    \color{black}
    \frontcoverjury
  \end{textblock}%
}

% Jury table on front cover
\newcommand{\frontcoverjury}{%
  \begin{flushleft}
    \small \if@french Composition du Jury\else Jury composition\fi{} :
  \end{flushleft}
  \small
  \newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{##1}}
  \newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}m{##1}}
  \begin{flushleft}
  \begin{tabular}{@{} L{8cm} R{3.5cm}}
    \@jurylist
  \end{tabular}
  \end{flushleft}%
}

\newcommand{\makefrontcover}{%
  \clearpage
  \thispagestyle{empty}
  \newgeometry{left=16mm,right=16mm,top=30mm,bottom=30mm}
  \color{black} \hfill \vfill \tiny \@ednum
  \frontcoverband
  \frontcoverlogos
  \frontcovercontent
  \null\newpage
  \restoregeometry
  \normalsize\rmfamily
}

%% ── Inner title page (like Petetin/Minerva style) ────────────────
%% Each sub-command can be individually overridden with \renewcommand.

% Logos on inner title page (ED logo left, school + IP Paris right)
\newcommand{\innertitlelogos}{%
  \begin{minipage}{0.45\textwidth}
    \flushleft
    \ifx\@edlogo\empty\else
      \includegraphics[height=20mm]{media/ed/\@edlogo}
    \fi
  \end{minipage}%
  \hfill
  \begin{minipage}{0.45\textwidth}
    \flushright
    \includegraphics[height=15mm]{media/etab/\@instlogo.png}\\[5mm]
    \includegraphics[height=12mm]{media/IPPARIS-petit.png}
  \end{minipage}%
}

% Header block: document type, specialty, author, institution
\newcommand{\innertitleheader}{%
  {\Large\scshape
    \if@hdr
      \if@french Habilitation à diriger des recherches\else Habilitation to Supervise Research\fi
    \else
      \if@french Thèse de doctorat\else Doctoral Thesis\fi
    \fi
  }

  \vspace{0.5cm}

  \if@french Discipline\else Specialty\fi : \@specialty

  \vspace{1.5cm}
  \if@french présentée par\else presented by\fi\\[0.5cm]
  {\LARGE\bfseries \@authorname}

  \vspace{0.3cm}
  {\small
    \@institution\\
    Laboratoire \@lab
  }%
}

% Title block with horizontal rules
\newcommand{\innertitlebody}{%
  \rule{\textwidth}{0.5pt}\\[0.5cm]
  {\Large\bfseries \@titleen}\\[0.5cm]
  \rule{\textwidth}{0.5pt}%
}

% Jury block on inner title page
\newcommand{\innertitlejury}{%
  {\small
    \if@french
      soutenue le \@defensedate\\
      devant le jury composé de :
    \else
      defended on \@defensedate\\
      before the jury composed of:
    \fi
  }

  \vspace{1cm}
  \begin{tabular}{@{} l l l}
    \@jurylist
  \end{tabular}%
}

\newcommand{\makeinnertitle}{%
  \clearpage
  \thispagestyle{empty}
  \begin{center}
    \vspace*{1cm}
    \innertitlelogos
    \vspace{2cm}
    \innertitleheader
    \vspace{1.5cm}
    \innertitlebody
    \vspace{2cm}
    \innertitlejury
  \end{center}
  \clearpage
}

%% ── Back cover ───────────────────────────────────────────────────
%% Each sub-command can be individually overridden with \renewcommand.

% French abstract block (title, keywords, abstract in two columns)
\newcommand{\backcoverfrench}{%
  \begin{center}
  \fcolorbox{black}{white}{\parbox{0.95\textwidth}{
    {\bf Titre :} \@titlefr
    \medskip

    {\bf Mots clés :} \@keywordsfr
    \vspace{-2mm}

    \begin{multicols}{2}
    {\bf Résumé :}
    \@abstractfr
    \end{multicols}
  }}
  \end{center}%
}

% English abstract block (title, keywords, abstract in two columns)
\newcommand{\backcoverenglish}{%
  \begin{center}
  \fcolorbox{black}{white}{\parbox{0.95\textwidth}{
    {\bf Title:} \@titleen
    \medskip

    {\bf Keywords:} \@keywordsen
    \vspace{-2mm}

    \begin{multicols}{2}
    {\bf Abstract:}
    \@abstracten
    \end{multicols}
  }}
  \end{center}%
}

% Back cover footer (IP Paris name + logo)
\newcommand{\backcoverfooter}{%
  \begin{textblock*}{140mm}(16mm,274mm)
    \colorbox{white}{\parbox{138mm}{%
      \color{black}
      {\bf\noindent Institut Polytechnique de Paris}\\
      \noindent 91120 Palaiseau, France%
    }}
  \end{textblock*}
  \begin{textblock*}{22mm}(170mm,270mm)
    \colorbox{white}{\includegraphics[width=20mm]{media/IPPARIS-petit}}
  \end{textblock*}%
}

\newcommand{\makebackcover}{%
  \cleardoublepage
  \thispagestyle{empty}
  \newgeometry{left=16mm,right=16mm,top=30mm,bottom=30mm}
  \textblockcolour{white}
  \ifx\@edlogo\empty\else
    \begin{textblock*}{61mm}(16mm,3mm)
      \noindent\includegraphics[height=24mm]{media/ed/\@edlogo}
    \end{textblock*}
  \fi
  \backcoverfrench
  \vspace*{0mm}
  \backcoverenglish
  \backcoverfooter
  \restoregeometry
}

%% ── Convenience environments ─────────────────────────────────────

% Dedication
\newenvironment{dedication}{%
  \cleardoublepage
  \thispagestyle{empty}
  \vspace*{\stretch{1}}
  \begin{flushright}\itshape
}{%
  \end{flushright}
  \vspace*{\stretch{3}}
  \cleardoublepage
}

% Acknowledgements
\newcommand{\acknowledgementstitle}{\if@french Remerciements\else Acknowledgements\fi}
\newenvironment{acknowledgements}{%
  \chapter*{\acknowledgementstitle}
  \addcontentsline{toc}{chapter}{\acknowledgementstitle}
}{%
}

% Foreword / Avant-propos
\newcommand{\forewordtitle}{\if@french Avant-propos\else Foreword\fi}
\newenvironment{foreword}{%
  \chapter*{\forewordtitle}
  \addcontentsline{toc}{chapter}{\forewordtitle}
}{%
}

%% ── Public language test (usable in user documents) ─────────────

\newcommand{\ifthesisfrench}[2]{\if@french #1\else #2\fi}
\newcommand{\ifthesishdr}[2]{\if@hdr #1\else #2\fi}

%% ── Document setup ───────────────────────────────────────────────

\AtBeginDocument{%
  \hypersetup{
    pdfauthor={\@authorname},
    pdftitle={\@titlefr},
    pdfsubject={%
      \if@hdr
        Habilitation à diriger des recherches
      \else
        Thèse de doctorat
      \fi
    },
  }
  \pagestyle{main}
  % Check that required logo files are present
  \@checklogofile{media/IPPARIS-petit-blanc.png}{Required for front cover band}%
  \@checklogofile{media/IPPARIS-texte-blanc.png}{Required for front cover band}%
  \@checklogofile{media/IPPARIS-petit.png}{Required for page footer and back cover}%
  \@checklogofile{media/etab/\@instlogo.png}{Required for front cover and inner title}%
}

\RequirePackage{multicol}

\endinput
