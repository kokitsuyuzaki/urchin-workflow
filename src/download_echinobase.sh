#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --nice=50
#SBATCH --requeue
#SBATCH -p node03-06
SLURM_RESTART_COUNT=2

wget -P data/echinobase/ https://download.echinobase.org/echinobase/Genomics/Spur5.0/$1".gz" --no-check-certificate
cd data/echinobase
gunzip $1".gz"
