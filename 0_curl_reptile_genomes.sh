#!/bin/sh

# This script downloads the genomic data used for building a reptile MHC database.

MHCPATH=yourpathhere

mkdir $MHCPATH/Reptile_data
cd $MHCPATH/Reptile_data

################################################
#### Pull genomes and annotations from NCBI ####
################################################

##### Crotalus tigris #####
curl -o tigris.zip 'https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_016545835.1/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED'

##### Naja naja #####
curl -o naja.zip 'https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCA_009733165.1/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED'

##### Ophiophagus hannah #####
curl -o hannah.zip 'https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCA_000516915.1/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED'

##### Protobothrops mucrosquamatus #####
curl -o mucros.zip 'https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_001527695.2/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED'

##### Python bivittatus #####
curl -o bivi.zip 'https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_000186305.1/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED'

##### Pantherophis guttatus #####
curl -o guttatus.zip 'https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_029531705.1/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED'

##### Thamnophis elegans #####
curl -o elegans.zip 'https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_009769535.1/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED'

##### Zootoca vivipera #####
curl -o vivi.zip 'https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_963506605.1/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED'

##### Podarcis uralis #####
curl -o muralis.zip 'https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_004329235.1/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED'

##### Lacerta agilis #####
curl -o agilis.zip 'https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_009819535.1/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED'

##### Anolis carolinensis #####
curl -o caro.zip 'https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_035594765.1/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED'

##### Varanus komodoensis #####
curl -o komodo.zip 'https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_004798865.1/download?include_annotation_type=GENOME_FASTA&include_annotation_type=GENOME_GFF&include_annotation_type=RNA_FASTA&include_annotation_type=CDS_FASTA&include_annotation_type=PROT_FASTA&include_annotation_type=SEQUENCE_REPORT&hydrated=FULLY_HYDRATED'

#####################################
#### Unzip and rename everything ####
#####################################
for i in tigris naja hannah mucros bivi guttatus elegans vivi muralis agilis caro komodo
do
unzip ${i}.zip
mv ncbi_dataset/data/* ${i}/
rm ${i}.zip
rm -r ncbi_dataset
done
