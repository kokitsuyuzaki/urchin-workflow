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

OUTDIR=`echo $4 | sed 's|Aligned.out.sam||g'`
STAR --runThreadN 4 \
--genomeDir $1 \
--readFilesIn $2 $3 \
--readFilesCommand zcat \
--outFileNamePrefix $OUTDIR
