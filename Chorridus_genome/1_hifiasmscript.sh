#!/bin/sh

# Script to assemble the C. horridus HiFi reference genome with hifiasm:
## Program install is available at https://github.com/chhylp123/hifiasm

# cd to directory created to run analysis
PATH=yourpathhere
cd $PATH

#-o = prefix of output files
#-t # of CPUs
#for inbred or homozygous genomes, you may disable purging with option -l0, otherwise purges haplotig duplications by default. C. horridus is likely not inbred enough to need.
# last part of the command is the input file
./hifiasm/hifiasm -o Cho.asm -t 48 combined.fasta
