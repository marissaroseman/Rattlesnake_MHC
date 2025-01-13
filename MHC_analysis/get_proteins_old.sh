#------------------------------------------------------------------------------------------------
#####################################################################################
###################### ALTERNATE CODE to extract protein seq ########################
#####################################################################################
# If you were using genes that were not already available in another file as protein sequences,
# you could use this code to get the nucleotide seqs from the gff and reference genome,
# then translate into protein seqs
# It's not very good code though, so use the above if possible.

## Split each entry in the matched_regions gtf so you can get the cds for each without loosing the info in the first line for each
## This splits with > as a delimiter that's not included, so I had to add that separating entries in the gtf
#for i in naja hannah bivi guttatus mucros tigris elegans
#do
# cd $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}
#csplit --quiet --prefix=out --suppress-matched all_${i}_matched_regions.gtf "/>/" "{*}"
done

## Then I manually renamed the outfiles b/c I'm not sure if there's a good way to name according to info in the file with csplit
## Names were like ${i}.geneID.gff

## Then I deleted the first line in each outfile since the info I needed was in the title and the first line wouldn't make it from gtf -> fasta
#for i in naja hannah bivi guttatus mucros tigris elegans
#do
#cd $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}
#sed -i '1d' ${i}.*

## For each gtf, get the fasta sequences
## Make a list of all the file names to use 
#ls > filenames.list
done

#cd ${PathToExtract_gff_feature_script}
#source activate biopython
#for i in naja hannah bivi guttatus mucros tigris elegans
#do
#while read -a line
#do
#python Extract_gff_feature_v0.1.py -s $MHCPATH/Reptile_data/${i}/*genomic.fna \
#-g $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}/${i}.${line}.gff \
#-f CDS \
#-o $MHCPATH/Get_Proteins/reptile_proteins/${i}/${i}.${line}.fasta
#done < $MHCPATH/Get_Proteins/matched_regions_by_sp/${i}/filenames.list

#	#Next concatenate all cds for a gene into 1 contiguous sequence
#	#Doing this by just deleting the lines starting with ">"
#	#Actually this isn't quite right b/c the Translate.py program needs the fasta header (first line) to work
#	#Need to find a way to delete all lines with ">" EXCEPT the first one, maybe can modify the sed command?
#sed -i '/^>/d' tigris.*.fasta

##	#Translate nucleotides to protein sequence
##	#Have to rename for each line before moving on tho the next one b/cTranslate.py doesn't allow naming the output 
## 	#so this would just write over the last file if we didn't rename it first.
#source activate biopython 
#while read -a line
#do
#python Translate.py -f ${line}.fasta
#mv tigris.faa tigris.${line}.faa
#mv tigris_internal_stop.faa tigris_internal_stop.${line}.faa
#done < /fs/scratch/PAS1504/PopGenom/MHC/Analyze_Ann_from_Pedro/get_protein_seqs/filenames.list