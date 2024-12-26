#!/bin/bash

## Called by parallel.sh which is in turn called by 6_fgenesh2gff.sh

#echo This is the name ${1};
#echo ${2};

cat /fs/scratch/PAS1533/marissa/MHC/6_fgenesh2gff/unadjusted_gffs/crad.${1}.gff | awk -v j=${2} '{$4 = j + $4 - 1; $5 = j + $5 - 1; print}' > /fs/scratch/PAS1533/marissa/MHC/6_fgenesh2gff/fixed_gffs/fgenesh.${1}.fixed.gff 
