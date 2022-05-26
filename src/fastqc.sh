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

mkdir -p data/$2/$3/$4_$5/fastqc
fastqc -o data/$2/$3/$4_$5/fastqc $1