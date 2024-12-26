# Rattlesnake_MHC
Code used to identify and analyze MHC genes in rattlesnake species

+---------------------------------+
| Build a database of MHC genes   |
+---------------------------------+

0_curl_reptile_genomes.sh
--To build a database of reptile MHC sequences, we first pull the reference genomes and gffs from ncbi.
--Associated files for each species will be put into $MHCPATH/Reptile_data/${species}/

1_process_gff.sh 
--Next we pull the MHC CDS and exons from the NCBI genome annotation gffs. 
--Each gene gets its own gff of all its CDS annotations, put into $MHCPATH/Reptile_genes/${species}/indiv_cds/cds.${line}.gff
--You must provide a list of the species names to use for the reptile database, one per line in $MHCPATH/Reptile_genes/reptiles.list

2_Extract.gff.sh
Extract_gff_feature_v0.2.py
--Then, for each species, we convert the gff to a fasta of the CDS sequence by running the program Extract_gff_feature_v0.2.py to pull the CDS from the genome fasta and the individual gene gffs generated in 1_process_gff.sh. 
--The resulting fastas will be put into $MHCPATH/Reptile_genes/${species}/cds_fastas/${CDSnumber}.fasta
--Fastas will be concatenated across reptile species into  $MHCPATH/Reptile_genes/concat.fastas/ReptileMHC_cds.fasta

+-----------------------+
| Run ToxCodAn-Genome   |
+-----------------------+

3_run_mhc_annotation.sh
--This script uses ToxCodAn-Genome to identify MHC genes, testing a few different parameters.
--ToxCodAn-Genome is available at for download at https://github.com/pedronachtigall/ToxCodAn-Genome
--The output of ToxCodAn-Genome will be put into $MHCPATH/Run_ToxCodAn-Genome/output/${StudySpecies}/${StudySpecies}_MHC_${parameters}

+--------------------------------------+
| Analyze matched regions in Fgenesh+  |
+--------------------------------------+

--This is to find MHC sequences from the "matched regions" output by ToxCodAn-Genome that did not produce definitive annotations
--To use Fgenesh+, we need the nucleotide seqs that are the putative genes in our target species and the protein seqs they match from other species.

4_get_proteins.sh
--This script uses grep to get the IDs for each matched gene from the other reptile species
--Then it pulls these proteins sequences from the downloaded protein.faa files from ncbi.
--Fastas of the proteins from the reptile species are put into $MHCPATH/Get_Proteins/reptile_proteins/${ReptileSpecies}_${GeneNumber}_prot.fa


5_get_matched_regions.sh
--This pulls the nucleotide sequences (putative genes) for our target sp from the matched_regions.gtf
--Fastas for the target species are placed into $MHCPATH/Get_Matched_Regions/${TargetSpecies}/split_fastas/${GeneNumber}.fasta

--Then, run through Fgenesh+
http://www.softberry.com/berry.phtml?topic=fgenes_plus&group=programs&subgroup=gfs
--The nucleotide seq comes from the matched regions of the target species
--The protein seq comes from the corresponding reptile gene used in the database
--For the organism option, we used Anolis carolinensis

--If it looks like the matched region only contains part of the gene, you can adjust the genomic coordinates in gtf.list and re-run part of 5_get_matched_regions.sh

--After adjusting genomic coordinates in the matched region as necessary, retain the Fgenesh+ output for complete putative genes (start and stop, look like appropriate length and # of exons)
--Copy the text to a textfile named with the matched_region number at ${MHCPATH}/fgenesh2gff/${species}/fgenesh_files/${line}.txt

+------------------------+
| Blast Fgenesh+ output  |
+------------------------+

--For each FGENESH+ output that passed the above requirements for a putative gene, we ran a nucleotide BLAST with blastn and a protein BLAST with blastp via https://blast.ncbi.nlm.nih.gov/Blast.cgi to ensure the top matches were for MHC genes. Sequences that did not produce high-confidence matches to MHC I or MHC IIB genes were discarded. 
--This process could be sped up with command-line blast, but we elected for the interactive features of the web version of BLAST.

+-----------------+
| Convert to gff  |
+-----------------+

6_fgenesh2gff.sh
fgenesh2gff.pl
parallel.sh
awk.sh
--After we have decided which fgenesh output files to retain, we need to convert them to a gff with the 6_fgenesh2gff.sh script.
--It calls  the fgenesh2gff.pl perl script from this biostars comment: https://www.biostars.org/p/4500/
--This requries the Bio::Tools::Fgenesh parser.
--Then we need to translate the genomic coordinates from the fgenesh output to be in reference to the genomic scaffolds.
--6_fgenesh2gff.sh next calls the parallel.sh script, which in turn runs the awk.sh script in parallel.
--The genomic offset used to recalculate the genomic coordinates comes from a file called start_coords.list which has the format:
geneID,offset,
and is generated as part of 6_fgenesh2gff.sh
--The final output of this script is the file ${MHCPATH}/fgenesh2gff/${species}_merged_fixed.gff which is a gff of all putative MHC annotations from the matched regions output of ToxCodAn-Genome

+---------------------+
| Curate in Geneious  |
+---------------------+

--We performed final curation of all putative MHC genes in Geneious: https://www.geneious.com/
--We imported the reference genome for our target species and the following annotation sources:
    -ToxCodAn-Genome annotations from: $MHCPATH/Run_ToxCodAn-Genome/output/${StudySpecies}/${StudySpecies}_MHC_${parameters}/toxin_annotation.gtf (this is just the automatic naming of the file, since ToxCodAn-Genome was originally designed for finding venom genes)
    -Processed matched regions from ${MHCPATH}/fgenesh2gff/${species}_merged_fixed.gff
    -Sequences from the whole-genome annotation, when available