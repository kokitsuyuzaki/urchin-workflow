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

salmon quant -i data/salmon_index \
-l A \
-1 data/$1_1/$1_1_paired.fastq.gz \
-2 data/$1_2/$1_2_paired.fastq.gz \
-o data/$1