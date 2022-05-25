import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

URCHIN_SAMPLES = pd.read_table('data/sample_sheet.csv',
    sep=',', dtype='string', header=None)[0]
URCHIN_SAMPLES = list(set(URCHIN_SAMPLES))
HPBASE_FILES = ['HpulGenome_v1_scaffold.fa', 'HpulGenome_v1_nucl.fa',
    'HpulGenome_v1_prot.fa', 'HpulTranscriptome.fa',
    'HpulTranscriptome_nucl.fa', 'HpulTranscriptome_prot.fa',
    'HpulGenome_v1_annot.xlsx', 'HpulGenome_v1.gff3']

rule all:
    input:
        expand('data/{sample}_1/fastqc/{sample}_1_fastqc.html',
            sample=URCHIN_SAMPLES),
        expand('data/{sample}_2/fastqc/{sample}_2_fastqc.html',
            sample=URCHIN_SAMPLES),
        expand('data/{sample}_1/fastqc_trim/{sample}_1_paired_fastqc.html',
            sample=URCHIN_SAMPLES),
        expand('data/{sample}_2/fastqc_trim/{sample}_2_paired_fastqc.html',
            sample=URCHIN_SAMPLES),
        expand('data/{sample}/Aligned.out.sam',
            sample=URCHIN_SAMPLES),
        expand('data/{sample}/quant.sf',
            sample=URCHIN_SAMPLES),
        # 'output/FeatureCounts.txt',
        # 'output/salmon_counts.txt',
        # 'data/multiqc_report.html',

#################################
# Data download
#################################
rule download_macrogen:
    output:
        'data/{sample}_1/{sample}_1.fastq.gz',
        'data/{sample}_2/{sample}_2.fastq.gz'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/download_{sample}.txt'
    log:
        'logs/download_{sample}.log'
    shell:
        'src/download_macrogen.sh {wildcards.sample} >& {log}'

rule download_hpbase:
    output:
        'data/hpbase/{file}'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/download_hpbase_{file}.txt'
    log:
        'logs/download_hpbase_{file}.log'
    shell:
        'src/download_hpbase.sh {wildcards.file} >& {log}'

rule download_adapter:
    output:
        'data/all_sequencing_WTA_adopters.fa'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/download_adapter.txt'
    log:
        'logs/download_adapter.log'
    shell:
        'src/download_adapter.sh >& {log}'

#################################
# QC, Trimming
#################################
rule fastqc_raw_1:
    input:
        'data/{sample}_1/{sample}_1.fastq.gz',
    output:
        'data/{sample}_1/fastqc/{sample}_1_fastqc.html',
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/fastqc_raw_1_{sample}.txt'
    log:
        'logs/fastqc_raw_1_{sample}.log'
    shell:
        'src/fastqc_raw_1.sh {wildcards.sample} >& {log}'

rule fastqc_raw_2:
    input:
        'data/{sample}_2/{sample}_2.fastq.gz',
    output:
        'data/{sample}_2/fastqc/{sample}_2_fastqc.html',
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/fastqc_raw_2_{sample}.txt'
    log:
        'logs/fastqc_raw_2_{sample}.log'
    shell:
        'src/fastqc_raw_2.sh {wildcards.sample} >& {log}'

rule trimmomatic:
    input:
        'data/{sample}_1/{sample}_1.fastq.gz',
        'data/{sample}_2/{sample}_2.fastq.gz',
        'data/all_sequencing_WTA_adopters.fa'
    output:
        'data/{sample}_1/{sample}_1_paired.fastq.gz',
        'data/{sample}_2/{sample}_2_paired.fastq.gz'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/trimmomatic_{sample}.txt'
    log:
        'logs/trimmomatic_{sample}.log'
    shell:
        'src/trimmomatic.sh {wildcards.sample} >& {log}'

rule fastqc_trim_1:
    input:
        'data/{sample}_1/{sample}_1_paired.fastq.gz',
    output:
        'data/{sample}_1/fastqc_trim/{sample}_1_paired_fastqc.html',
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/fastqc_trim_1_{sample}.txt'
    log:
        'logs/fastqc_trim_1_{sample}.log'
    shell:
        'src/fastqc_trim_1.sh {wildcards.sample} >& {log}'

rule fastqc_trim_2:
    input:
        'data/{sample}_2/{sample}_2_paired.fastq.gz',
    output:
        'data/{sample}_2/fastqc_trim/{sample}_2_paired_fastqc.html',
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/fastqc_trim_2_{sample}.txt'
    log:
        'logs/fastqc_trim_2_{sample}.log'
    shell:
        'src/fastqc_trim_2.sh {wildcards.sample} >& {log}'

#################################
# Alignment-based Quantification
#################################
rule star_index:
    input:
        'data/hpbase/HpulGenome_v1_scaffold.fa',
        'data/hpbase/HpulGenome_v1.gff3'
    output:
        'data/star_index/SAindex'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/star_index.txt'
    log:
        'logs/star_index.log'
    shell:
        'src/star_index.sh >& {log}'

rule star:
    input:
        'data/star_index',
        'data/{sample}_1/{sample}_1_paired.fastq.gz',
        'data/{sample}_2/{sample}_2_paired.fastq.gz'
    output:
        'data/{sample}/Aligned.out.sam'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/star_{sample}.txt'
    log:
        'logs/star_{sample}.log'
    shell:
        'src/star.sh {wildcards.sample} >& {log}'

#################################
# Alignment-free Quantification
#################################
rule salmon_index:
    input:
        'data/hpbase/HpulTranscriptome.fa'
    output:
        'data/salmon_index/sa.bin'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/salmon_index.txt'
    log:
        'logs/salmon_index.log'
    shell:
        'src/salmon_index.sh >& {log}'

rule salmon_count:
    input:
        'data/salmon_index',
        'data/{sample}_1/{sample}_1_paired.fastq.gz',
        'data/{sample}_2/{sample}_2_paired.fastq.gz'
    output:
        'data/{sample}/quant.sf'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/salmon_count_{sample}.txt'
    log:
        'logs/salmon_count_{sample}.log'
    shell:
        'src/salmon_count.sh {wildcards.sample} >& {log}'

#################################
# Summary
#################################
rule featurecounts:
    input:
        expand('data/{sample}/Aligned.out.sam',
            sample=URCHIN_SAMPLES)
    output:
        'output/FeatureCounts.txt'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/featurecounts.txt'
    log:
        'logs/featurecounts.log'
    shell:
        'src/featurecounts.sh >& {log}'

rule tximport:
    input:
        expand('data/{sample}/quant.sf',
            sample=URCHIN_SAMPLES)
    output:
        'output/salmon_counts.txt'
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

rule multiqc:
    input:
        expand('data/{sample}_1/fastqc/{sample}_1_fastqc.html',
            sample=URCHIN_SAMPLES),
        expand('data/{sample}_2/fastqc/{sample}_2_fastqc.html',
            sample=URCHIN_SAMPLES),
        expand('data/{sample}_1/fastqc_trim/{sample}_1_paired_fastqc.html',
            sample=URCHIN_SAMPLES),
        expand('data/{sample}_2/fastqc_trim/{sample}_2_paired_fastqc.html',
            sample=URCHIN_SAMPLES),
        expand('data/{sample}/Aligned.out.sam',
            sample=URCHIN_SAMPLES),
        expand('data/{sample}/quant.sf',
            sample=URCHIN_SAMPLES)
    output:
        'data/multiqc_report.html'
    resources:
        mem_gb=100
    container:
        'quay.io/biocontainers/multiqc:1.12--pyhdfd78af_0'
    benchmark:
        'benchmarks/multiqc.txt'
    log:
        'logs/multiqc.log'
    shell:
        'src/multiqc.sh >& {log}'

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
