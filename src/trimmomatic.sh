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
-trimlog $8 \
$1 \
$2 \
$4 \
$5 \
$6 \
$7 \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36 \
ILLUMINACLIP:$3:2:30:10
