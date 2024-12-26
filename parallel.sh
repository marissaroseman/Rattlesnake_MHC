#!/bin/bash

## Called by 6_fgenesh2gff.sh

cat /fs/scratch/PAS1533/marissa/MHC/6_fgenesh2gff/startcoords.list | parallel 'name=$(echo {} | cut -d, -f1); start=$(echo {} | cut -d, -f2); sh /fs/scratch/PAS1533/marissa/MHC/scripts/awk.sh ${name} ${start}'
