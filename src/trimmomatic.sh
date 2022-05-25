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

trimmomatic PE \
-threads 4 \
-phred33 \
-trimlog data/$1_1/log.txt \
data/$1_1/$1_1.fastq.gz \
data/$1_2/$1_2.fastq.gz \
data/$1_1/$1_1_paired.fastq.gz \
data/$1_1/$1_1_unpaired.fastq.gz \
data/$1_2/$1_2_paired.fastq.gz \
data/$1_2/$1_2_unpaired.fastq.gz \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36 \
ILLUMINACLIP:data/all_sequencing_WTA_adopters.fa:2:30:10
