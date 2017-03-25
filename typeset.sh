#!/bin/bash

alias ts='./typeset.sh'

pdflatex --file-line-error --synctex=1 --shell-escape "wavelets.tex"

bibtex wavelets

pdflatex --file-line-error --synctex=1 --shell-escape "wavelets.tex"

pdflatex --file-line-error --synctex=1 --shell-escape "wavelets.tex"

rm wavelets.aux
rm wavelets.log
rm wavelets.bbl
rm wavelets.blg
rm wavelets.synctex.gz
