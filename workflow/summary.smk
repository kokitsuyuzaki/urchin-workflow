import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

URCHIN_SAMPLES, = glob_wildcards('data/220524_RNAseq/{sample}_1.fastq')

TYPES = ['trim', 'raw']
DBS1 = ['hpbase', 'echinobase']
DBS2 = ['hpbase', 'hpbase_nucl', 'echinobase']

rule all:
    input:
        expand('data/{db1}/{type}/multiqc_report.html',
            db1=DBS1, type=TYPES),
        expand('data/{db1}/{type}/mapping_rate.txt',
            db1=DBS1, type=TYPES),
        expand('output/FeatureCounts_{db1}_{type}.txt',
            db1=DBS1, type=TYPES),
        expand('output/SalmonCounts_{db2}_{type}.txt',
            db2=DBS2, type=TYPES),
        expand('output/SalmonTPMs_{db2}_{type}.txt',
            db2=DBS2, type=TYPES)

#################################
# Summary
#################################
rule multiqc:
    input:
        expand('data/{db1}/raw/{sample}_1/fastqc/{sample}_1_fastqc.html',
            db1=DBS1, sample=URCHIN_SAMPLES),
        expand('data/{db1}/raw/{sample}_2/fastqc/{sample}_2_fastqc.html',
            db1=DBS1, sample=URCHIN_SAMPLES),
        expand('data/{db1}/trim/{sample}_1/fastqc/{sample}_1_paired_fastqc.html',
            db1=DBS1, sample=URCHIN_SAMPLES),
        expand('data/{db1}/trim/{sample}_2/fastqc/{sample}_2_paired_fastqc.html',
            db1=DBS1, sample=URCHIN_SAMPLES),
        expand('data/{db1}/{type}/{sample}/star/Aligned.out.sam',
            db1=DBS1, type=TYPES, sample=URCHIN_SAMPLES),
        expand('data/{db1}/{type}/{sample}/salmon/quant.sf',
            db1=DBS1, type=TYPES, sample=URCHIN_SAMPLES)
    output:
        'data/{db1}/{type}/multiqc_report.html'
    resources:
        mem_mb=1000000
    container:
        'docker://quay.io/biocontainers/multiqc:1.12--pyhdfd78af_0'
    benchmark:
        'benchmarks/multiqc_{db1}_{type}.txt'
    log:
        'logs/multiqc_{db1}_{type}.log'
    shell:
        'src/multiqc.sh {wildcards.db1} {wildcards.type} >& {log}'

rule export_mapping_rate:
    input:
        'data/{db1}/{type}/multiqc_report.html'
    output:
        'data/{db1}/{type}/mapping_rate.txt'
    resources:
        mem_mb=1000000
    container:
        'docker://quay.io/biocontainers/multiqc:1.12--pyhdfd78af_0'
    benchmark:
        'benchmarks/export_mapping_rate_{db1}_{type}.txt'
    log:
        'logs/export_mapping_rate_{db1}_{type}.log'
    shell:
        'src/export_mapping_rate.sh {wildcards.db1} {wildcards.type} {output} >& {log}'

rule featurecounts_merge:
    input:
        expand('data/{db1}/{type}/{sample}/star/Aligned.out.sam',
            db1=DBS1, type=TYPES, sample=URCHIN_SAMPLES)
    output:
        'output/FeatureCounts_{db1}_{type}.txt'
    resources:
        mem_mb=1000000
    container:
        'docker://koki/urchin_workflow_bioconda:20220527'
    benchmark:
        'benchmarks/featurecounts_merge_{db1}_{type}.txt'
    log:
        'logs/featurecounts_merge_{db1}_{type}.log'
    shell:
        'src/featurecounts_merge.sh {wildcards.db1} {wildcards.type} {output} >& {log}'

rule tximport:
    input:
        expand('data/{db2}/{type}/{sample}/salmon/quant.sf',
            db2=DBS2, type=TYPES, sample=URCHIN_SAMPLES)
    output:
        'output/SalmonCounts_{db2}_{type}.txt',
        'output/SalmonTPMs_{db2}_{type}.txt'
    resources:
        mem_mb=1000000
    container:
        'docker://koki/urchin_workflow_r:20220531'
    benchmark:
        'benchmarks/tximport_{db2}_{type}.txt'
    log:
        'logs/tximport_{db2}_{type}.log'
    shell:
        'src/tximport.sh {wildcards.db2} {wildcards.type} {output} >& {log}'
