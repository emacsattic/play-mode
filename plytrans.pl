#!/usr/bin/perl
#
# Translate ply files into LaTeX.

$\=$/="\n\n";

print <<'LaTeX';
\documentclass[letterpaper]{article}
\usepackage{newplay}
LaTeX

while (<>){
  s,\s*title:\s*(.*\S)\s*$,$title="$1 -"; "\\title{$1}",gem && next;
  s,\s*author:\s*(.*\S)\s*$,\\author{$1},gm && next;
  s/[aA][cC][tT]\:\s*(.*\S)\s*$/\\section{$title Act $1}/mg;
  s,[sS][cC][eE][nN][eE]:\s*(.*\S)\s*$,\\subsection{Scene $1},gm;
  s,"([^"]*)",\`\`$1",g;
  s,/([^/]+)/,\\textit{$1},g;
  s,^\s*\[\s*([^\]]+\S)\s*\]\s*$,\\longdirection{[$1]},g;
  s,\s*[^{]\[\s*([^\]]+\S)\s*\]\s*, \\direction{[$1]} ,g;
  s,^\s*([^=]+\S)\s*=\s*(.*\S)\s*,\\line{$1}{$2},smg;
  s,\.\s*\.\s*\.,\\dots,g;
  print;
}
print qq(\\end{document});
