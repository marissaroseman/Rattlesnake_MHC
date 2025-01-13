#!/bin/sh

## This script converts the output of the FGENESH+ web program into a gff and corrects the genomic coordinates to be in reference to the original scaffold, not just the extracted sequence given to FGENESH+.

## Copy and paste the text output of FGENESH+ into individual files at ${MHCPATH}/fgenesh2gff/fgenesh_files

## Replace variables with your info
species=yourspecieshere
MHCPATH=yourpathhere
PathTofgenesh2gffPearlScript=yourpathhere
## If all matches are one one scaffold for the study species, replace with the scaffold name:
SCAF=CM077919.1


##########################################################################################
### 1a) Start here if the matches for the species are on multiple different scaffolds: ###
##########################################################################################
## extract the column with scaffold names:
    mkdir -r ${MHCPATH}/fgenesh2gff/${species}
    cd ${MHCPATH}/fgenesh2gff/${species}
    cp $MHCPATH/Run_ToxCodAn-Genome/output/${species}/${species}*/matched_regions.gtf ./${species}_matched_regions.gff
	cut -f 1 ${species}_matched_regions.gff > scaffolds.list

## Sort the lines for each scaffold into a new file
	while read -a line
	do 
	grep ${line} ${species}.numbered_matched_regions.gff > ${line}.list
	done < scaffolds.list

## Now we need a list of the line numbers that use each scaffold:
	while read -a line
	do 
	cut -f 1 ${line}.list > lines.${line}.list
	done < unique.${species}.scaffolds.list

## Run the script to extract the gff from the fgenesh output:
	while read -a scaf 
	do
	while read -a line
	do
	perl ${PathTofgenesh2gffPearlScript}/cnv_fgenesh2gff.pl -i ${MHCPATH}/fgenesh2gff/${species}/fgenesh_files/${line}.txt \
	--gff-ver GFF3 --seqname ${scaf} --html --outfile ${MHCPATH}/fgenesh2gff/${species}/unadjusted_gffs/${species}.${line}.gff
	done < ${MHCPATH}/lines.${scaf}.list
	done < ${MHCPATH}/unique.${species}.scaffolds.list

## Last thing is to fix the gene IDs:

## For all:
	cd ${MHCPATH}/unadjusted_gffs
	sed -i 's/fgenesh_gene/scat_gene/g' *.gff

## Adjust values as necessary for the number of gene files you have
    for i in {000..133}
    do 
    sed -i "s/gene00001/gene${i}/g" ${species}.$i.gff
    done


#****************************************************************************************************************************************
############################################################################################################
### 1b) Start here if the matches for a species are all on one scaffold (skip if on multiple scaffolds): ###
############################################################################################################
## Run the script to extract the gff from the fgenesh output:
	
    cd ${PathTofgenesh2gffPearlScript}

    while read -a line
    do
    perl cnv_fgenesh2gff.pl -i ${MHCPATH}/fgenesh2gff/fgenesh_files/${line} \
    --gff-ver GFF3 --seqname ${SCAF} --html --outfile ${MHCPATH}/fgenesh2gff/unadjusted_gffs/${species}.${line}.gff
    done < ${MHCPATH}/fgenesh2gff/kept.list

## Last thing is to fix the gene IDs:
## Note: use double quotes with variables

## For all:
    cd ${MHCPATH}/fgenesh2gff/unadjusted_gffs
    sed -i 's/fgenesh_gene/${species}_gene/g' *.gff

    while read -a line
    do 
    sed -i "s/gene00001/gene${line}/g" "${species}.${line}.gff"
    done < ${MHCPATH}/fgenesh2gff/kept.list

## To reduce the 0s in the exon names:
    sed -i 's/exon000/exon/g' *.gff
    
#****************************************************************************************************************************************
################################################################################################
### 2) Now do the addition to get the right coordinates for the files generated with fgenesh ###
################################################################################################

## First we need to generate startcoords.list
## This is the gene #,startcoord from the matched_regions gff used.
## eg: 002,1296421,

## make a file with all the kept gtfs
    cd ${MHCPATH}/fgenesh2gff
    while read -a line
    do
    cat ${MHCPATH}/Get_Matched_Regions/split_gtfs/out${line} >> all.kept.gtf
    done < kept.list

## Get the start coords
    cat all.kept.gtf | cut -f4 > temp.startcoords.list

## Add line #s
    paste -d "," kept.list temp.startcoords.list > startcoords.list

## Finally, run the scripts. This runs parallel.sh which then runs awk.sh.
#You first need to adjust the paths. It is trickier to just set a path variable within parallel, so just type out the paths:
#1) path to startcoords.list files needs to be fixed in parallel.sh script
#2) path to awk.sh needs to be fixed in the parallel.sh script
#3) path to unadjusted gff file inputs needs to be fixed in the awk.sh script
#4) path to fixed gff file outputs needs to be fixed in the awk.sh script

    mkdir ${MHCPATH}/fgenesh2gff/fixed_gffs
    source activate parallel
    sh ${MHCPATH}/scripts/parallel.sh 
	
#Then pull only the files that have anything in them (only needed if your startcoords list included files that weren't retained)
	find -maxdepth 1 -size +0c -exec mv {} ../fixed_gffs \;
	cat ${MHCPATH}/${species}_numbered_matched_regions.gff | cut -f4 > ${species}.startcoords.list

#****************************************************************************************************************************************
######################################
### 3) Concatenate into 1 gff file ###
######################################

cd ${MHCPATH}/fgenesh2gff/fixed_gffs    
cat *.gff > ../${species}_merged_fixed.gff

## For the original files, if the tab spacing gets messed up, do:
cd ${MHCPATH}/fgenesh2gff
awk -v OFS="\t" '$1=$1' ${species}_merged_fixed.gff > ${species}_merged_fixed2.gff
mv ${species}_merged_fixed2.gff ${species}_merged_fixed.gff