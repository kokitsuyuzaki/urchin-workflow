import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

container: 'docker://koki/urchin_workflow_r:20220531'

DEGMETHODS = ['edger', 'deseq2']
STAGES = ['11h', '14h', '18h', '24h']

rule all:
    input:
        expand('output/deg/{deg}/FeatureCounts_hpbase_trim_{stage}.RData',
            deg=DEGMETHODS, stage=STAGES),
        expand('output/deg/{deg}/FeatureCounts_hpbase_trim_{stage}_all.txt',
            deg=DEGMETHODS, stage=STAGES),
        expand('output/deg/{deg}/FeatureCounts_hpbase_trim_{stage}_deg.txt',
            deg=DEGMETHODS, stage=STAGES),

#################################
# DEGs detection
#################################
rule deg_edger:
    input:
        "output/FeatureCounts_hpbase_trim.txt"
    output:
        "output/deg/edger/FeatureCounts_hpbase_trim_{stage}.RData",
        "output/deg/edger/FeatureCounts_hpbase_trim_{stage}_all.txt",
        "output/deg/edger/FeatureCounts_hpbase_trim_{stage}_deg.txt",
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/deg_edger_{stage}.txt'
    log:
        'logs/deg_edger_{stage}.log'
    shell:
        'src/deg_edger.sh {input} {output} {wildcards.stage} >& {log}'

rule deg_deseq2:
    input:
        "output/FeatureCounts_hpbase_trim.txt"
    output:
        "output/deg/deseq2/FeatureCounts_hpbase_trim_{stage}.RData",
        "output/deg/deseq2/FeatureCounts_hpbase_trim_{stage}_all.txt",
        "output/deg/deseq2/FeatureCounts_hpbase_trim_{stage}_deg.txt",
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/deg_deseq2_{stage}.txt'
    log:
        'logs/deg_deseq2_{stage}.log'
    shell:
        'src/deg_deseq2.sh {input} {output} {wildcards.stage} >& {log}'
