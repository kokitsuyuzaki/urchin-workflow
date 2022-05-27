import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

container: 'docker://koki/urchin_workflow_bioconda:20220527'

rule all:
    input:
        expand('data/{db}/star_index/Log.out',
            db=['hpbase', 'echinobase']),
        expand('data/{db}/salmon_index/sa.bin',
            db=['hpbase', 'echinobase'])

#################################
# Alignment-based Quantification
#################################
rule index_star_hpbase:
    input:
        'data/hpbase/HpulGenome_v1_scaffold.fa',
        'data/hpbase/HpulGenome_v1.gff3'
    output:
        'data/hpbase/star_index/Log.out'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/star_index_hpbase.txt'
    log:
        'logs/star_index_hpbase.log'
    shell:
        'src/star_index_hpbase.sh >& {log}'

rule index_star_echinobase:
    input:
        'data/echinobase/sp5_0_GCF_genomic.fa',
        'data/echinobase/sp5_0_GCF.gff3'
    output:
        'data/echinobase/star_index/Log.out'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/star_index_echinobase.txt'
    log:
        'logs/star_index_echinobase.log'
    shell:
        'src/star_index_echinobase.sh >& {log}'

#################################
# Alignment-free Quantification
#################################
rule index_salmon_hpbase:
    input:
        'data/hpbase/HpulTranscriptome.fa'
    output:
        'data/hpbase/salmon_index/sa.bin'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/salmon_index.txt'
    log:
        'logs/salmon_index.log'
    shell:
        'src/salmon_index_hpbase.sh >& {log}'

rule index_salmon_echinobase:
    input:
        'data/echinobase/sp5_0_GCF_transcripts.fa'
    output:
        'data/echinobase/salmon_index/sa.bin'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/salmon_index.txt'
    log:
        'logs/salmon_index.log'
    shell:
        'src/salmon_index_echinobase.sh >& {log}'
