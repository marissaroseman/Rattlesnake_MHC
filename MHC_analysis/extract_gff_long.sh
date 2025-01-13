#!/bin/sh -l
#SBATCH -A PAS1504
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -t 2:00:00
#SBATCH --job-name=process_matched_regions
#SBATCH -o process_matched_regions%j

cd /fs/scratch/PAS1504/PopGenom/MHC
source activate biopython

for i in tigris naja hannah mucros bivittatus guttatus elegans vivipera muralis agilis carolinensis komodo
do
while read -a line
do
python Extract_gff_feature_v0.1_old.py \
-s /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/Reptile_genes/elegans/elegans_genomic.fa \
-g /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/indiv_cds/${line} \
-f CDS \
-o ${line}.fasta
done < /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/filenames/elegans.filenames.list

#guttatus
while read -a line
do
python Extract_gff_feature_v0.1_old.py \
-s /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/Reptile_genes/guttatus/guttatus_genomic.fa \
-g /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/indiv_cds/${line} \
-f CDS \
-o ${line}.fasta
done < /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/filenames/guttatus.filenames.list

#hannah
while read -a line
do
python Extract_gff_feature_v0.1_old.py \
-s /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/Reptile_genes/hannah/hannah_genomic.fa \
-g /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/indiv_cds/${line} \
-f CDS \
-o ${line}.fasta
done < /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/filenames/hannah.filenames.list

#mucros
while read -a line
do
python Extract_gff_feature_v0.1_old.py \
-s /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/Reptile_genes/mucros/mucros_genomic.fa \
-g /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/indiv_cds/${line} \
-f CDS \
-o ${line}.fasta
done < /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/filenames/mucros.filenames.list

#naja
while read -a line
do
python Extract_gff_feature_v0.1_old.py \
-s /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/Reptile_genes/naja/naja_genomic.fa \
-g /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/indiv_cds/${line} \
-f CDS \
-o ${line}.fasta
done < /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/filenames/naja.filenames.list

#tigris
while read -a line
do
python Extract_gff_feature_v0.1_old.py \
-s /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/Reptile_genes/tigris/tigris_genomic.fa \
-g /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/indiv_cds/${line} \
-f CDS \
-o ${line}.fasta
done < /fs/scratch/PAS1504/PopGenom/MHC/6_oreganus_matched_regions/get_protein_seqs/filenames/tigris.filenames.list 
