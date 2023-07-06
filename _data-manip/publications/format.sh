#!/usr/bin/env bash

##PDF directory
pdfdir=../../pubs

##Clear old PDF files
rm $pdfdir/*pdf

##Move .bib file to this folder
[ -f My-Pubs/My-Pubs.bib ] && mv My-Pubs/My-Pubs.bib .

##Move PDFs to pdfdir & remove empty folder
##https://www.cyberciti.biz/faq/linux-unix-bsd-xargs-construct-argument-lists-utility/
find My-Pubs/ -name *pdf -print0 | xargs -0 -I file mv file $pdfdir
rm -r My-Pubs/

##Edit .bib file to reflect new pdf paths
sed -i -E 's/.pdf:files.+},$/.pdf},/g' My-Pubs.bib

##Stop (and keep window open, https://stackoverflow.com/a/52096639) if My-Pubs.bib is empty
if ! [[ -s My-Pubs.bib ]] ; then 
	read -p "Error: My-Pubs.bib is empty after sed command. Press ^c to continue" x
	exit
fi

##Make .bib safe for reading by bib2df by removing within-field newlines
rmnewline () {
	 awk $1 '/[^,}]$/ { printf("%s;;;", $0); next } 1'
}
cat My-Pubs.bib | rmnewline | rmnewline > My-Pubs.bib

##Stop (and keep window open, https://stackoverflow.com/a/52096639) if My-Pubs.bib is empty
if ! [[ -s My-Pubs.bib ]] ; then 
	read -p "Error: My-Pubs.bib is empty after rmnewline command. Press ^c to continue" x
	exit
fi

##Convert .bib to other formats
Rscript -e "rmarkdown::render('BibTeX-Conversions.Rmd')"
