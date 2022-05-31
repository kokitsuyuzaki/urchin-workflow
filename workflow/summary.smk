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
        expand('data/{db}/{type}/mapping_rate.txt',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw']),
        expand('output/FeatureCounts_{db}_{type}.txt',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw']),
        expand('output/SalmonCounts_{db}_{type}.txt',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw']),
        expand('output/SalmonTPMs_{db}_{type}.txt',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw'])

#################################
# Summary
#################################
rule multiqc:
    input:
        expand('data/{db}/raw/{sample}_1/fastqc/{sample}_1_fastqc.html',
            db=['hpbase', 'echinobase'],
            sample=URCHIN_SAMPLES),
        expand('data/{db}/raw/{sample}_2/fastqc/{sample}_2_fastqc.html',
            db=['hpbase', 'echinobase'],
            sample=URCHIN_SAMPLES),
        expand('data/{db}/trim/{sample}_1/fastqc/{sample}_1_paired_fastqc.html',
            db=['hpbase', 'echinobase'],
            sample=URCHIN_SAMPLES),
        expand('data/{db}/trim/{sample}_2/fastqc/{sample}_2_paired_fastqc.html',
            db=['hpbase', 'echinobase'],
            sample=URCHIN_SAMPLES),
        expand('data/{db}/{type}/{sample}/star/Aligned.out.sam',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw'],
            sample=URCHIN_SAMPLES),
        expand('data/{db}/{type}/{sample}/salmon/quant.sf',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw'],
            sample=URCHIN_SAMPLES)
    output:
        'data/{db}/{type}/multiqc_report.html'
    resources:
        mem_gb=100
    container:
        'docker://quay.io/biocontainers/multiqc:1.12--pyhdfd78af_0'
    benchmark:
        'benchmarks/multiqc_{db}_{type}.txt'
    log:
        'logs/multiqc_{db}_{type}.log'
    shell:
        'src/multiqc.sh {wildcards.db} {wildcards.type} >& {log}'

rule export_mapping_rate:
    input:
        'data/{db}/{type}/multiqc_report.html'
    output:
        'data/{db}/{type}/mapping_rate.txt'
    resources:
        mem_gb=100
    container:
        'docker://quay.io/biocontainers/multiqc:1.12--pyhdfd78af_0'
    benchmark:
        'benchmarks/export_mapping_rate_{db}_{type}.txt'
    log:
        'logs/export_mapping_rate_{db}_{type}.log'
    shell:
        'src/export_mapping_rate.sh {wildcards.db} {wildcards.type} {output} >& {log}'

rule featurecounts_merge:
    input:
        expand('data/{db}/{type}/{sample}/star/Aligned.out.sam',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw'],
            sample=URCHIN_SAMPLES)
    output:
        'output/FeatureCounts_{db}_{type}.txt'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220527'
    benchmark:
        'benchmarks/featurecounts_merge_{db}_{type}.txt'
    log:
        'logs/featurecounts_merge_{db}_{type}.log'
    shell:
        'src/featurecounts_merge.sh {wildcards.db} {wildcards.type} {output} >& {log}'

rule tximport:
    input:
        expand('data/{db}/{type}/{sample}/salmon/quant.sf',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw'],
            sample=URCHIN_SAMPLES)
    output:
        'output/SalmonCounts_{db}_{type}.txt',
        'output/SalmonTPMs_{db}_{type}.txt'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_r:20220528'
    benchmark:
        'benchmarks/tximport_{db}_{type}.txt'
    log:
        'logs/tximport_{db}_{type}.log'
    shell:
        'src/tximport.sh {wildcards.db} {wildcards.type} {output} >& {log}'
