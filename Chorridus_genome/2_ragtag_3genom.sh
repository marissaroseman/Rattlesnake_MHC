#!/bin/sh

## Code to scaffold the C. horridus genome assembly to three different genomes, then merge the three into a consensus
## This uses a conda install of RagTag: https://github.com/malonge/RagTag
## Conda install is availalble with:
#conda install bioconda::ragtag

source activate ragtag

PATH=yourpathhere
cd $PATH

# The first argument after the flags is the more contiguous genome you want to scaffold to
# The second argument is the de novo genome you want to scaffold
# -r is to infer gap sizes from the alignment (vs default 100 Ns)
ragtag.py scaffold -r -o out_1 CroVir_3.0_genomic.fa hifiasm.fa 
ragtag.py scaffold -r -o out_2 Cadamanteus_3dDNAHiC_1.2.fasta hifiasm.fa 
ragtag.py scaffold -r -o out_3 Scatenatus_HiC_v1.1.fasta hifiasm.fa

#Then get a consensus of the three scaffolded assembies
ragtag.py merge hifiasm.fa out_*/*.agp