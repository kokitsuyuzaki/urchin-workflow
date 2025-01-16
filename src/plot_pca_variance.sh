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

export R_LIBS_USER="/usr/local/lib/R/site-library"
export R_LIBS_SITE=""

Rscript src/plot_pca_variance.R $@
if [ $? -ne 0 ]; then
    touch $4
    touch $5
fi

