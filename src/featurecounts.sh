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

featureCounts -t exon \
-g gene_id \
-a data/hpbase/HpulGenome_v1.gff3 \
-o output/FeatureCounts.txt \
data/*/Aligned.out.sam
