import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

rule all:
    input:


#################################
# DEGs, Plots, ...etc
#################################
# 以降は
# container: 'docker://koki/urchin_workflow_r:20220525'
# を使う
# tximport
# DEG: edgeR/DESeq2
# Enrichment Analysis
# PCA, t-SNE
# Plot (Venn diagram, two-D)
