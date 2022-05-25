import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.5.3")

URCHIN_SAMPLES = pd.read_table('data/sample_sheet.csv',
    sep=',', dtype='string', header=None)[0]
HPBASE_FILES = ['HpulGenome_v1_scaffold.fa', 'HpulGenome_v1_nucl.fa',
    'HpulGenome_v1_prot.fa', 'HpulTranscriptome.fa',
    'HpulTranscriptome_nucl.fa', 'HpulTranscriptome_prot.fa',
    'HpulGenome_v1_annot.xlsx', 'HpulGenome_v1.gff3']

rule all:
    input:
        expand('data/{sample}/{sample}.fastq.gz',
            sample=URCHIN_SAMPLES),
        expand('data/hpbase/{file}',
            file=HPBASE_FILES),

rule download_macrogen:
    output:
        'data/{sample}/{sample}.fastq.gz'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/download_{sample}.txt'
    log:
        'logs/download_{sample}.log'
    shell:
        'src/download.sh {wildcards.sample} >& {log}'

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

# FastQC（raw）: 'data/{sample}/fastqc/raw'

# Trimmomatic: 'data/{sample}/{sample}_trim.fastq.gz'

# FastQC（trimmed）: 'data/{sample}/fastqc/trim'

# STAR: 'data/{sample}/{sample}_trim.bam'

# feature_counts: *.bamで一気にマージできる

# salmon index/count: Transcriptomeから




# 以降は
# container: 'docker://koki/urchin_workflow_r:XXXXXX'
# を使う
# DEG: edgeR/DESeq2
# Enrichment Analysis
# PCA, t-SNE
# Plot (Venn diagram, two-D)
