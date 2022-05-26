import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

URCHIN_SAMPLES, = glob_wildcards('data/{sample}_1.fastq.gz')

rule all:
    input:
        expand('data/{db}/{type}/multiqc_report.html',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw']),
        # expand('output/{db}/{type}/FeatureCounts.txt',
        #     db=['hpbase', 'echinobase'],
        #     type=['trim', 'raw']),
        # expand('output/{db}/{type}/SalmonCounts.txt',
        #     db=['hpbase', 'echinobase'],
        #     type=['trim', 'raw']),

#################################
# Summary
#################################
rule multiqc:
    input:
        expand('data/{db}/{type}/{sample}_1/fastqc/{sample}_1_fastqc.html',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw'],
            sample=URCHIN_SAMPLES),
        expand('data/{db}/{type}/{sample}_2/fastqc/{sample}_2_fastqc.html',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw'],
            sample=URCHIN_SAMPLES),
        expand('data/{db}/{type}/{sample}/Aligned.out.sam',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw'],
            sample=URCHIN_SAMPLES),
        expand('data/{db}/{type}/{sample}/quant.sf',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw'],
            sample=URCHIN_SAMPLES)
    output:
        'data/{db}/{type}/multiqc_report.html'
    resources:
        mem_gb=100
    container:
        'quay.io/biocontainers/multiqc:1.12--pyhdfd78af_0'
    benchmark:
        'benchmarks/multiqc_{db}_{type}.txt'
    log:
        'logs/multiqc_{db}_{type}.log'
    shell:
        'src/multiqc.sh {wildcards.db} {wildcards.type} >& {log}'

# rule featurecounts_merge:
#     input:
#         expand('data/{sample}/Aligned.out.sam',
#             sample=URCHIN_SAMPLES)
#     output:
#         'output/FeatureCounts.txt'
#     resources:
#         mem_gb=100
#     container:
#         'docker://koki/urchin_workflow_bioconda:20220525'
#     benchmark:
#         'benchmarks/featurecounts.txt'
#     log:
#         'logs/featurecounts.log'
#     shell:
#         'src/featurecounts_merge.sh >& {log}'

rule tximport:
    input:
        expand('data/{sample}/quant.sf',
            sample=URCHIN_SAMPLES)
    output:
        'output/SalmonCounts.txt'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_r:20220525'
    benchmark:
        'benchmarks/tximport.txt'
    log:
        'logs/tximport.log'
    shell:
        'src/tximport.sh >& {log}'