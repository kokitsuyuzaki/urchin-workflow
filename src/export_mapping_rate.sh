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

FILE='data/'$1'/'$2'/multiqc_data/multiqc_general_stats.txt'
grep "Aligned.out.sam" $FILE > $3
