#!/usr/bin/env bash

##Delete pdf files currently in this folder (but not subfolders)
rm *pdf

##Move .bib file to this folder
[ -f My-Pubs/My-Pubs.bib ] && mv My-Pubs/My-Pubs.bib .

##Move pdfs to this folder
##https://www.cyberciti.biz/faq/linux-unix-bsd-xargs-construct-argument-lists-utility/
find My-Pubs/ -name *pdf -print0 | xargs -0 -I file mv file .

##Edit .bib file to reflect new pdf paths
sed -i -E 's/.pdf:files.+},$/.pdf},/g' My-Pubs.bib

##Make .bib safe for reading by bib2df by removing within-field newlines
rmnewline () {
	 awk $1 '/[^,}]$/ { printf("%s;;;", $0); next } 1'
}
cat My-Pubs.bib | rmnewline | rmnewline > My-Pubs.bib

##Remove empty folder
rm -r My-Pubs
