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

STAR --runMode genomeGenerate \
--runThreadN 4 \
--genomeDir data/hpbase/star_index/ \
--genomeFastaFiles data/hpbase/HpulGenome_v1_scaffold.fa \
--sjdbGTFfile data/hpbase/HpulGenome_v1.gff3 \
--limitGenomeGenerateRAM 34000000000
