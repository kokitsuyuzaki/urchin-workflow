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

wget -P data/ https://bioinformatics.riken.jp/ramdaq/ramdaq_annotation/mouse/all_sequencing_WTA_adopters.fa --no-check-certificate
