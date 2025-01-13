#!/bin/sh

# Script for getting fastas of proteins in other reptile species
# that matched to the target snake species

MHCPATH=yourpathhere
PathToExtract_gff_feature_script=yourpathhere

#######################################################################
### Split the matched_regions.gtf file by the species it matched to ###
#######################################################################
for a in horridus oreganus adamanteus catenatus 
do
mkdir -p $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}
# Only do for species that had a match in the snake genomes 
for i in naja hannah bivi guttatus mucros tigris elegans
do
grep $i $MHCPATH/Run_ToxCodAn-Genome/output/${a}/${a}*/matched_regions.gtf \
> $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}/${i}_matched_regions_in_${a}.gtf
done
done

####################################
### Combine across snake species ###
####################################
for i in naja hannah bivi guttatus mucros tigris elegans
do
cat $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}/*.gtf \
> $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}/all_${i}_matched_regions.gtf

#########################################
### Get just the ID in the 9th column ###
#########################################
cut -f 9 $MHCPATH/Get_Proteins/matched_regions_by_sp/all_${i}_matched_regions \
> $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}_matched_IDs 
done

###########################################################################
### Get just the gene ID (after species name and before MHC class type) ###
###########################################################################
## Note: this only works when the other sp gff used "genus.species" in the gene IDs, so it doesn't work for tigris.
for i in naja hannah bivi guttatus mucros elegans
do
cut -d '.' -f 3 $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}_matched_IDs \
> $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}_matched_gene_nums 
done

for i in tigris
do
cut -d '.' -f 2 $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}_matched_IDs \
> $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}_matched_gene_nums 
done

##############################
### Keep only unique lines ###
##############################
for i in naja hannah bivi guttatus mucros tigris elegans
do
sort -u $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}_matched_gene_nums  \
> $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}_unique_matched_gene_nums 
done

#####################################################################################
### Extract the protein seq from the protein.faa provided in ncbi genome download ###
#####################################################################################
## using sed, the command format is "sed -n '/start/,/stop/p' myfile" 
## -n means don't print anything until we ask for it
## /start/ will find the first line with this pattern
## , means continue until
## /stop/ means stop when we find that pattern
## p prints the matched lines
## We pipe this into head to delete the last line, as sed includes the line of the stop pattern.

for i in naja hannah bivi guttatus mucros tigris elegans
do
mkdir $MHCPATH/Get_Proteins/reptile_proteins
while read -a line
do
sed -n '/'$line'/,/>/p' $MHCPATH/Reptile_data/${i}/protein.faa | head -n -1 \
> $MHCPATH/Get_Proteins/reptile_proteins/${i}_${line}_prot.fa
done < $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}_unique_matched_gene_nums 
done
