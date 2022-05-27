import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

rule all:
    input:

#################################
# DEGs and Plots
#################################
# 以降は
# 'docker://koki/urchin_workflow_r:20220527'
# を使う
# PCA, t-SNE
# 2次元プロット
# DEG: edgeR/DESeq2
# 棒グラフ（+/-）
# Enrichment Analysis
# Excelシートにして、あらゆる情報を渡す