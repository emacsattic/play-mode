#!/usr/bin/perl
#
#

$/='\n\n';
@foo=<>;
@bar = split m/\n\n/s, $foo[0];

print q(
\documentclass[letterpaper]{article}
\parindent 0pt
\usepackage{fancyheadings}

\renewcommand{\part}{\@startsection{part}%
  {-1}%
  {-1mm}%
  {-\baselineskip}%
  {0.5\baselineskip}%
  {\normalfont}}%%
\newcommand{\marginlabel}[1]
  {\mbox{}\marginpar{\raggedleft\hspace{0pt}#1}}
\pagestyle{fancy}
\addtolength{\headwidth}{\marginparsep}
\addtolength{\headwidth}{\marginparwidth}
\title{Deathtrap}
\rhead[\fancyplain{}{\bfseries\leftmark}]%
      {\fancyplain{}{\bfseries\thepage}}
      \cfoot[]{}
      %\pagestyle{headings}
      \begin{document}
      \author{Ira Levin}
      %\pagenumbering{arabic}
      \maketitle
      \reversemarginpar
      );
foreach (@bar) {
	m/^\s*\w+\s*:/ && next;
	##FIXMEs,\G"([^"]*)",\`\`$1",g;
	s,/([^/]+)/,\\textit{$1},g;
	#s,(\[[^\]]+\]),\\textit{\\textbf{$1}},g;
	s,^\s*\[\s*([^\]]+)\]\s*$,\\begin{quotation}\\textsf{[$1]}\\end{quotation},g;
	s,\[\s*([^\]]+)\s*\],\\textsf{[$1]},g;
	#s,<brack>,[,g;
	#s,<cbrack>,],g;
	s,^\s*([^=]+)\s*=,{\\hspace\*{-0.5in}\\textsc{$1 }},g;
	s,\.\s*\.\s*\.,\\dots,g;
	print;
print "\n\n";

}
print q(\end{document}),"\n";
