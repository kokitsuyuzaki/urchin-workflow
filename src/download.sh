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

wget -P data/$1 https://data.macrogen.com/~macro3/HiSeq02/20220523/HN00169897/$1.fastq.gz