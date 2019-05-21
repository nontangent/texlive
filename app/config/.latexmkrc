#!/usr/bin/perl

$latex                       = 'uplatex -synctex=1 -halt-on-error %O %S';
$bibtex                      = 'upbibtex %O %B';
$dvipdf                      = 'dvipdfmx %O -o %D %S';
$makeindex                   = 'mendex -U %O -o %D %S';
$max_repeat                  = 5;
$pdf_mode                    = 3; # generates pdf via dvipdfmx

# Prevent latexmk from removing PDF after typeset.
# This enables Skim to chase the update in PDF automatically.
$pvc_view_file_via_temporary = 0;
$pdf_previewer = '';
