#!/usr/bin/perl
#
# Translate ply files into LaTeX.

$\=$/="\n\n";

print <<'EO_TeX';
\documentclass[letterpaper]{article}
\parindent 0pt
\usepackage{fancyheadings}

\pagestyle{fancy}
\addtolength{\headwidth}{\marginparsep}
\addtolength{\headwidth}{\marginparwidth}
\title{Deathtrap}
\lhead[\fancyplain{}{\bfseries\thepage}]%
      {\fancyplain{}{\bfseries\rightmark}}
\rhead[\fancyplain{}{\bfseries\leftmark}]%
      {\fancyplain{}{\bfseries\thepage}}
\cfoot[]{}
%\pagestyle{headings}
\begin{document}
\author{Ira Levin}
%\pagenumbering{arabic}
\maketitle
\reversemarginpar

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

while (<>){
  m/^\s*\w+\s*:/ && next;
  s,"([^"]*)",\`\`$1",g;
  s,/([^/]+)/,\\textit{$1},g;
  s,^\s*\[\s*([^\]]+\S)\s*\]\s*$,\\longdirection{[$1]},g;
  s,\s*[^{]\[\s*([^\]]+\S)\s*\]\s*, \\direction{[$1]} ,g;
  s,^\s*([^=]+\S)\s*=\s*(.*\S)\s*,\\line{$1}{$2},smg;
  s,\.\s*\.\s*\.,\\dots,g;
  print;
}
print qq(\\end{document});
