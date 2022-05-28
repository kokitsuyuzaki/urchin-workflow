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

if [ $1 = "hpbase" ]; then
	ANNOTATION=data/hpbase/HpulGenome_v1.gff3
else
	ANNOTATION=data/echinobase/sp5_0_GCF.gff3
fi

featureCounts -t exon \
-T 4 \
-p \
-F "GFF3" \
-g "Parent" \
-a $ANNOTATION \
-o $3 \
data/$1/$2/*/star/Aligned.out.sam \
--verbose
