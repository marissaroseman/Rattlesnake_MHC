#!/bin/sh

## Script for running ToxCodAn-Genome
## See Nachtigall et al. (2024) ToxCodAn-Genome: an automated pipeline for toxin-gene annotation in genome assembly of venomous lineages. Giga Science. DOI: https://doi.org/10.1093/gigascience/giad116
## Program available for download at https://github.com/pedronachtigall/ToxCodAn-Genome
## Note: this script was written for running a beta-version of ToxCodAn-Genome. 
    ##This should work the same for the published version, but if you encounter any issues, refer to the ToxCodAn-Genome github!

MHCPATH=yourpathhere

########## Set-up files ##########

## Set up directories for each target species containing the fasta for the reference genome
## Also set up an output folder
for i in horridus oreganus adamanteus catenatus 
do
mkdir -p $MHCPATH/Run_ToxCodAn-Genome/input/${i}
mkdir -p $MHCPATH/Run_ToxCodAn-Genome/output/${i}
done
## Eg $MHCPATH/Run_ToxCodAn-Genome/input/horridus needs to contain the ref genome for horridus. 
## Ref genome should be named like horridus.ref.fasta

## Make sure you concatenated the individual fastas for MHC CDS in other reptiles into one file called ReptileMHC_cds.fasta
## The beta version of ToxCodAn-Genome could only handle capital letters in the fasta. 
    ## Not sure if this is still the case but if it comes up as an issue, something you may need to adjust.
cp $MHCPATH/Reptile_genes/concat.fastas/ReptileMHC_cds.fasta $MHCPATH/Run_ToxCodAn-Genome/input/

########## Set-up ToxCodAn-Genome ##########

##To install all dependencies needed through conda, run:
#conda create -n ToxcodanGenome -c bioconda python biopython pandas blast exonerate miniprot gffread hisat2 samtools stringtie trinity spades
source activate ToxcodanGenome

## Get the program
cd $MHCPATH/Run_ToxCodAn-Genome/
#git clone https://github.com/pedronachtigall/ToxCodAn-Genome.git

## Follow instructions on the ToxCodAn-Genome github to add it to your path
    ## Or just make sure you have execute perms and run the program from the bin
    ## Change perms with:
# chmod +x $MHCPATH/Run_ToxCodAn-Genome/ToxCodAn-Genome/bin/toxcodan-genome.py

##Params:
## -g is genome to search
## -d is database - concatenated fasta of cds, with only lowercase type
## -o is output name
## -c is cpu threads to use
## -p is percent identity threshold
## --maxgenesize is threshold for max length of gene

########## Running the program for target species ##########
# If you are running from the program source bin, you need to cd into that directory. If you added it to your bashrc profile, ignore the next line:
cd $MHCPATH/Run_ToxCodAn-Genome/ToxCodAn-Genome/bin

for i in horridus oreganus adamanteus catenatus 
do
./toxcodan-genome.py -g $MHCPATH/Run_ToxCodAn-Genome/input/${i}/${i}.ref.fasta -d $MHCPATH/Run_ToxCodAn-Genome/input/ReptileMHC_cds.fasta -o $MHCPATH/Run_ToxCodAn-Genome/output/${i}/${i}_MHC_default -c 6
./toxcodan-genome.py -g $MHCPATH/Run_ToxCodAn-Genome/input/${i}/${i}.ref.fasta -d $MHCPATH/Run_ToxCodAn-Genome/input/ReptileMHC_cds.fasta -o $MHCPATH/Run_ToxCodAn-Genome/output/${i}/${i}_MHC_gs40K -c 6 --maxgenesize 40000
./toxcodan-genome.py -g $MHCPATH/Run_ToxCodAn-Genome/input/${i}/${i}.ref.fasta -d $MHCPATH/Run_ToxCodAn-Genome/input/ReptileMHC_cds.fasta -o $MHCPATH/Run_ToxCodAn-Genome/output/${i}/${i}_MHC_p70gs40K -c 6 --maxgenesize 40000 -p 70
./toxcodan-genome.py -g $MHCPATH/Run_ToxCodAn-Genome/input/${i}/${i}.ref.fasta -d $MHCPATH/Run_ToxCodAn-Genome/input/ReptileMHC_cds.fasta -o $MHCPATH/Run_ToxCodAn-Genome/output/${i}/${i}_MHC_p70gs50K -c 6 --maxgenesize 50000 -p 70
./toxcodan-genome.py -g $MHCPATH/Run_ToxCodAn-Genome/input/${i}/${i}.ref.fasta -d $MHCPATH/Run_ToxCodAn-Genome/input/ReptileMHC_cds.fasta -o $MHCPATH/Run_ToxCodAn-Genome/output/${i}/${i}_MHC_p90gs40K -c 6 --maxgenesize 40000 -p 90
./toxcodan-genome.py -g $MHCPATH/Run_ToxCodAn-Genome/input/${i}/${i}.ref.fasta -d $MHCPATH/Run_ToxCodAn-Genome/input/ReptileMHC_cds.fasta -o $MHCPATH/Run_ToxCodAn-Genome/output/${i}/${i}_MHC_p90gs50K -c 6 --maxgenesize 50000 -p 90
./toxcodan-genome.py -g $MHCPATH/Run_ToxCodAn-Genome/input/${i}/${i}.ref.fasta -d $MHCPATH/Run_ToxCodAn-Genome/input/ReptileMHC_cds.fasta -o $MHCPATH/Run_ToxCodAn-Genome/output/${i}/${i}_MHC_p60gs50K -c 6 -p 60
./toxcodan-genome.py -g $MHCPATH/Run_ToxCodAn-Genome/input/${i}/${i}.ref.fasta -d $MHCPATH/Run_ToxCodAn-Genome/input/ReptileMHC_cds.fasta -o $MHCPATH/Run_ToxCodAn-Genome/output/${i}/${i}_MHC_p70gs60Kv2 -c 6 -p 70 --maxgenesize 60000
done

# When this finishes, assess the output to pick which set of parameters to use. 
# Ideally you want to maximize the number of genes identified while minimizing the number of putatively low-quality annotations listed in annotation_warning.txt
# Delete or move all other output folders that you will not be using.
# rename the output directory you will use to "kept"
# eg mv horrius_MHC_p70gs50K ./kept