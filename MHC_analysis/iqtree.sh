#!/bin/sh -l
#SBATCH -A PAS1504
#SBATCH -N 1
#SBATCH -n 28
#SBATCH -t 6:00:00
#SBATCH --job-name=iqtre
#SBATCH -o iqtree

#This is the script for building trees with iqtree:
#http://www.iqtree.org/doc/Tutorial
#Citation:
#S. Kalyaanamoorthy, B.Q. Minh, T.K.F. Wong, A. von Haeseler, and L.S. Jermiin (2017) ModelFinder: fast model selection for accurate phylogenetic estimates. Nat. Methods, 14:587–589. DOI: 10.1038/nmeth.4285

#I used sequences that were aligned with the translation align function using MUSCLE in GeneiousPrime.
#I'm using a codon position partitioning scheme specified in the nexus file. 

#-spp lets each partition (codon position) have their own evolution rate
# -m MFP+MERGE is to use ModelFinderPlus and start with the full partition model, then merge genes until it no longer increases model fit
#-bb is bootstraps

#------------------------
source activate iqtree
#For MHCI
iqtree -s /fs/scratch/PAS1533/marissa/horridus_mhc/iq_tree/aligned_files/MHCI_Translation_alignment.phy -pre MHCI \
-spp /fs/scratch/PAS1533/marissa/horridus_mhc/iq_tree/mhcI.partitions.nex \
-m MFP+MERGE -bb 1000 


#For MHCIIB 
iqtree -s /fs/scratch/PAS1533/marissa/horridus_mhc/iqtree/aligned_files/MHCIIB_Translation_alignment.phy -pre MHCIIB \
-spp /fs/scratch/PAS1533/marissa/horridus_mhc/iq_tree/mhcIIB.partitions.nex \
-m MFP+MERGE -bb 1000 