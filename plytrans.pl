#!/usr/bin/perl
#
# Translate ply files into LaTeX.

$\=$/="\n\n";

print <<'EO_TeX';
\documentclass[letterpaper]{article}
\usepackage{fancyheadings}
EO_TeX

$header = <<'EO_TeX';
\pagestyle{fancyplain}

\setcounter{secnumdepth}{-2}
\addtolength{\headwidth}{\marginparsep}
\addtolength{\headwidth}{\marginparwidth}
\renewcommand{\sectionmark}[1]%
    {\markboth{#1}{}\thispagestyle{empty}}
\renewcommand{\subsectionmark}[1]%
    {\markright{#1}}
\lhead[\fancyplain{}{\bfseries\thepage}]%
      {\fancyplain{}{\bfseries\rightmark}}
\chead[\fancyplain{}{\bfseries\leftmark}]%
      {\fancyplain{}{\bfseries\leftmark}}
\rhead[\fancyplain{}{\bfseries\rightmark}]%
      {\fancyplain{}{\bfseries\thepage}}
\cfoot[]{}

\parindent 0pt

% Need to look at this one again.
% I'm not sure which way I like it.
%\reversemarginpar

\begin{document}
%\maketitle
% Needed for \line version 3
\newlength{\nameoutdent}

% Set to whatever length you want the gap to be
\newlength{\namegap}
%\setlength{\namegap}{0pt}
\setlength{\namegap}{1em}

% Original
%\def\line#1#2{{\hspace*{-0.5in}\textsc{#1  }}#2}
% This works perfectly well
%\def\line#1#2%
%{\setbox0=\hbox{\textsc{#1  }}{\hspace*{-\wd0}\box0}#2}

% Version 3, lets you add a gap
\def\line#1#2
{
  \setbox0=\hbox{\textsc{#1  }}
  \setlength{\nameoutdent}{\wd0}
  \addtolength{\nameoutdent}{\namegap}
  \leavevmode\kern-\nameoutdent\hbox to \nameoutdent{\box0\hfil}#2
}

\def\longdirection#1
{\begin{quotation}\noindent\textsf{\textbf{#1}}\end{quotation}}

\def\direction#1
{\textsf{\textbf{#1 }}}

EO_TeX

%metakeys={};
$text="";
while (<>){
  s/[aA][cC][tT]\:\s*(.*\S)\s*$/\\section{$metakeys{'title'} - Act $1}/mg;
  s,[sS][cC][eE][nN][eE]:\s*(.*\S)\s*$,\\subsection{Scene $1},gm;
  s,\s*(title|author):\s*(.*\S)\s*$,$metakeys{$1}=$2; "",gem && next;
  s,"([^"]*)",\`\`$1",g;
  s,/([^/]+)/,\\textit{$1},g;
  s,^\s*\[\s*([^\]]+\S)\s*\]\s*$,\\longdirection{[$1]},g;
  s,\s*[^{]\[\s*([^\]]+\S)\s*\]\s*, \\direction{[$1]} ,g;
  s,^\s*([^=]+\S)\s*=\s*(.*\S)\s*,\\line{$1}{$2},smg;
  s,\.\s*\.\s*\.,\\dots,g;
  $text.="$_\n\n";
}
print "\\title{$metakeys{'title'}}\n\\author{$metakeys{'author'}}\n";
print $header;
print $text;
print qq(\\end{document});
