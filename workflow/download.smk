import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

container: 'docker://koki/urchin_workflow_bioconda:20220527'

URCHIN_SAMPLES = pd.read_table('data/sample_sheet.csv',
    sep=',', dtype='string', header=None)[0]
URCHIN_SAMPLES = list(set(URCHIN_SAMPLES))

HPBASE_FILES = ['HpulGenome_v1_scaffold.fa', 'HpulGenome_v1_nucl.fa',
    'HpulGenome_v1_prot.fa', 'HpulTranscriptome.fa',
    'HpulTranscriptome_nucl.fa', 'HpulTranscriptome_prot.fa',
    'HpulGenome_v1_annot.xlsx', 'HpulGenome_v1.gff3']
ECHINOBASE_FILES = ['sp5_0_GCF_genomic.fa',
    'sp5_0_GCF.gff3', 'sp5_0_GCF_transcripts.fa']

rule all:
    input:
        expand('data/{sample}_1.fastq.gz',
            sample=URCHIN_SAMPLES),
        expand('data/{sample}_2.fastq.gz',
            sample=URCHIN_SAMPLES),
        expand('data/hpbase/{file}',
            file=HPBASE_FILES),
        expand('data/echinobase/{file}',
            file=ECHINOBASE_FILES),
        'data/all_sequencing_WTA_adopters.fa'

#################################
# Data download
#################################
rule download_macrogen:
    output:
        'data/{sample}_1.fastq.gz',
        'data/{sample}_2.fastq.gz'
    resources:
        mem_gb=100
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
    benchmark:
        'benchmarks/download_hpbase_{file}.txt'
    log:
        'logs/download_hpbase_{file}.log'
    shell:
        'src/download_hpbase.sh {wildcards.file} >& {log}'

rule download_echinobase:
    output:
        'data/echinobase/{file}'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/download_echinobase_{file}.txt'
    log:
        'logs/download_echinobase_{file}.log'
    shell:
        'src/download_echinobase.sh {wildcards.file} >& {log}'

rule download_adapter:
    output:
        'data/all_sequencing_WTA_adopters.fa'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/download_adapter.txt'
    log:
        'logs/download_adapter.log'
    shell:
        'src/download_adapter.sh >& {log}'
