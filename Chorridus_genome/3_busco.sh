#!/bin/sh

## Code for assessing genome completeness with BUSCO
## This uses a busco conda environment, which can be installed with:
#conda install bioconda::busco

source activate busco

PATH=yourpathhere

busco -i $PATH/Cho.asm.bp.p_ctg.fa -l sauropsida_odb10 -o hifiasm_busco -m genome -c 48
	#-i gives the input fasta file you want to use
	#-l gives the lineage dataset to use. It will download it if you don't already have it, which takes longer. Check availabale datasets with busco --list-datasets
	#-o names the output
	#-m sets the mode (genome, proteins, transcriptome)
	#-c sets the # of cores to use
