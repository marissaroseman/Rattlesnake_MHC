#!/bin/sh

## This script extract the sequence of each matched region identified by ToxCodAn-Genome and splits them into separate fasta files.

MHCPATH=yourpathhere
PathToExtract_gff_feature_script=yourpathhere

#######################################################################
### Get the nuc seqs for each matched region in matched_regions.gtf ###
#######################################################################

# First, matched_regions.gtf has "match" in the source column. 
# This isn't recognized by the Extract_gff_feature script, so for convenience's sake, we are going to change it to CDS

for i in horridus oreganus adamanteus catenatus 
do
cd $MHCPATH/Run_ToxCodAn-Genome/output/${i}/${i}*
sed -i 's/match/CDS/g' matched_regions.gtf

###########################################################################################################################################
### Then split each entry into a separate gtf file, or else extract_gff_feature will try to concat all regions matched to the same gene ###
###########################################################################################################################################

mkdir -p $MHCPATH/Get_Matched_Regions/${i}/split_gtfs
cd $MHCPATH/Get_Matched_Regions/${i}/split_gtfs
csplit --quiet --prefix=out $MHCPATH/Run_ToxCodAn-Genome/output/${i}/${i}*/matched_regions.gtf "/CDS/" "{*}"
rm out00

#######################################
### Then get the fasta for each gtf ###
#######################################

ls > gtf.list
done

source activate biopython
cd $PathToExtract_gff_feature_script

for i in horridus oreganus adamanteus catenatus 
do
mkdir -p $MHCPATH/Get_Matched_Regions/${i}/split_fastas
while read -a line
do
python Extract_gff_feature_v0.1.py -s $MHCPATH/Reptile_data/${i}/*genomic.fasta \
-g $MHCPATH/Get_Matched_Regions/${i}/split_gtfs/${line} \
-f CDS \
-o $MHCPATH/Get_Matched_Regions/${i}/split_fastas/${line}.fasta
done < $MHCPATH/Get_Matched_Regions/${i}/split_gtfs/gtf.list
done

#****************************************************************************************************************************************
#############################################################################
### If you need to adjust the coordinates, do so and re-run starting here ###
#############################################################################
# Hash out everything above this and make sure you have the gtf.mod.list file, which is the relevant lines of gtf.list with the coordinates adjusted as needed.
# For the first run, leave this hashed out.

#for i in horridus oreganus adamanteus catenatus 
#do
#while read -a line
#do
#python Extract_gff_feature_v0.1.py -s $MHCPATH/Reptile_data/${i}/*genomic.fasta \
#-g $MHCPATH/Get_Matched_Regions/${i}/split_gtfs/${line} \
#-f CDS \
#-o $MHCPATH/Get_Matched_Regions/${i}/split_fastas/${line}.fasta
#done < $MHCPATH/Get_Matched_Regions/${i}/split_gtfs/gtf.mod.list
#done
