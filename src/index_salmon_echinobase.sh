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

salmon index -t data/echinobase/sp5_0_GCF_transcripts.fa \
-i data/echinobase/salmon_index \
-k 31