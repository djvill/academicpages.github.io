#!/usr/bin/env bash

##Move .bib file to this folder
[ -f My-Pubs/My-Pubs.bib ] && mv My-Pubs/My-Pubs.bib .

##Move pdfs to this folder
##https://www.cyberciti.biz/faq/linux-unix-bsd-xargs-construct-argument-lists-utility/
find My-Pubs/ -name *pdf -print0 | xargs -0 -I file mv file .

##Edit .bib file to reflect new pdf paths
sed -i -E 's/:files.+\.pdf/.pdf/g' My-Pubs.bib

##Remove empty folder
rm -r My-Pubs
