#!/bin/sh

# This script is to extract fastas of annotated MHC genes from reference genomes based on genomic coordinates in a gff
# The sequences are concatenated into one Reptile MHC database fasta file.

MHCPATH=yourpathhere
PathToExtract_gff_feature_script=yourpathtoscripthere
cd $MHCPATH/Reptile_genes

#Call conda environment for biopython
source activate biopython

########## Get filenames ##########

for i in tigris naja hannah mucros bivi guttatus elegans vivi muralis agilis caro komodo
do
cd $MHCPATH/Reptile_genes/$i/indiv_cds
ls > $MHCPATH/Reptile_genes/$i/cds.names.list
cd $MHCPATH/Reptile_genes/$i
mkdir cds_fastas
done
########## Get a fasta of the seq, retaining the gene product information ##########

for i in tigris naja hannah mucros bivi guttatus elegans vivi muralis agilis caro komodo
do
cd $PathToExtract_gff_feature_script
while read -a line
do
python Extract_gff_feature_v0.2.py \
-s $MHCPATH/Reptile_data/$i/${i}_genomic.fna \
-g $MHCPATH/Reptile_genes/$i/indiv_cds/${line} \
-f CDS \
-o $MHCPATH/Reptile_genes/$i/cds_fastas/${line}.fasta \
-d Product
done < $MHCPATH/Reptile_genes/$i/cds.names.list
done

########## Concatenate fastas ##########
## For each species:
mkdir $MHCPATH/Reptile_genes/concat.fastas
for i in tigris naja hannah mucros bivi guttatus elegans vivi muralis agilis caro komodo
do 
cd $MHCPATH/Reptile_genes/$i/cds_fastas
cat *.fasta > $MHCPATH/Reptile_genes/concat.fastas/${i}.cds.concat.fasta
done

## Then combine species:
cd $MHCPATH/Reptile_genes/concat.fastas
cat *.fasta > ReptileMHC_cds.fasta
