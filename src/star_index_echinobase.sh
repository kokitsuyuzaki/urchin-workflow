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
--genomeDir data/echinobase/star_index/ \
--genomeFastaFiles data/echinobase/sp5_0_GCF_genomic.fa \
--sjdbGTFfile data/echinobase/sp5_0_GCF.gff3 \
--limitGenomeGenerateRAM 34000000000
