#!/bin/sh

## This script is to pull MHC CDS and exons from a gff file. 
## It pulls entries with 'MHC' or 'histocompatability' but discards entries that have terms suggesting non-classical MHC
## Reptiles.list is a text file that should contain all the species names to include, one per line, and they need to match the annotation gffs.

MHCPATH=yourpathhere

mkdir MHCPATH/Reptile_genes
cd $MHCPATH/Reptile_genes

while read -a line
do
cd $MHCPATH/Reptile_genes
mkdir ${line}
cd ${line}
gzip -d *.gff.gz
grep -i 'MHC\|histocompatibility' $MHCPATH/Reptile_data/${line}/*.gff > all.${line}.MHC.txt
grep -v 'transactivator\|regulatory\|minor\|gamma' all.${line}.MHC.txt > filtered.${line}.MHC.txt
awk -F'\t' '$3 == "CDS"' filtered.${line}.MHC.txt > cds.${line}.gff
awk -F'\t' '$3 == "exon"' filtered.${line}.MHC.txt > exon.${line}.gff
##Then split the cds file into individual files, one per gene.
##We are telling awk to use tab, ;, and = as field delimiters.
##Then write/append each line to a file named after the cds ID
awk -F"\t|;|=" '{print>$10}' cds.${line}.gff
#Put the files into a new folder
mkdir indiv_cds
mv cds-* indiv_cds
mkdir indiv_exons
mv exon-* indiv_exons
mkdir indiv_rna
mv rna-* indiv_rna
mkdir indiv_gene
mv gene-* indiv_gene
done < reptiles.list
