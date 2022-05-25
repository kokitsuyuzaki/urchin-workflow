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

STAR --runThreadN 4 \
--genomeDir data/star_index \
--readFilesIn data/$1_1/$1_1_paired.fastq.gz data/$1_2/$1_2_paired.fastq.gz \
--readFilesCommand zcat \
--outFileNamePrefix data/$1/
