#!/usr/bin/perl
#
# Translate ply files into LaTeX.

$\=$/="\n\n";

$newfile = $filename = $ARGV[0];
$newfile =~ s/.ply$/.tex/;
print $filename, $newfile;
open(INFILE,"<$filename");
open(OUTFILE,">$newfile");
print OUTFILE <<'LaTeX';
\documentclass[letterpaper]{article}
\usepackage{newplay}
\begin{document}
LaTeX

while (<INFILE>){
  s,\s*title:\s*(.*\S)\s*$,$title="$1 -"; "\\title{$1}",gem && next;
  s,\s*author:\s*(.*\S)\s*$,\\author{$1},gm && next;
  s/[aA][cC][tT]\:\s*(.*\S)\s*$/\\section{$title Act $1}/mg;
  s,[sS][cC][eE][nN][eE]:\s*(.*\S)\s*$,\\subsection{Scene $1},gm;
  s,"([^"]*)",\`\`$1",g;
  s,\.\s*\.\s*\.,\\dots,g;
  s,/([^/]+)/,\\textit{$1},g;
  s,\*\*([^\*]+)\*\*,\\textbf{$1},g;
  s,^\s*\[\s*([^\]]+\S)\s*\]\s*$,\\longdirection{[$1]},g;
  s,\s*[^{]\[\s*([^\]]+\S)\s*\]\s*, \\direction{[$1]} ,g;
  s,^\s*([^=]+\S)\s*=\s*(.*\S)\s*,\\line{$1}{$2},smg;
  print OUTFILE $_;
}
print OUTFILE qq(\\end{document});
