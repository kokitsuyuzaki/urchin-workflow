import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

container: 'docker://koki/urchin_workflow_bioconda:20220527'

URCHIN_SAMPLES, = glob_wildcards('data/{sample}_1.fastq.gz')

rule all:
    input:
        expand('data/{db}/{type}/{sample}/salmon/quant.sf',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw'],
            sample=URCHIN_SAMPLES),
        expand('data/{db}/{type}/{sample}/featurecounts/featurecounts.summary',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw'],
            sample=URCHIN_SAMPLES)

#################################
# Alignment-based Quantification
#################################
rule star_raw:
    input:
        'data/{db}/star_index',
        'data/{sample}_1.fastq.gz',
        'data/{sample}_2.fastq.gz'
    output:
        'data/{db}/raw/{sample}/star/Aligned.out.sam'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/star_raw_{db}_{sample}.txt'
    log:
        'logs/star_raw_{db}_{sample}.log'
    shell:
        'src/star.sh {input} {output} >& {log}'

rule star_trim:
    input:
        'data/{db}/star_index',
        'data/{db}/trim/{sample}_1/{sample}_1_paired.fastq.gz',
        'data/{db}/trim/{sample}_2/{sample}_2_paired.fastq.gz'
    output:
        'data/{db}/trim/{sample}/star/Aligned.out.sam'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/star_trim_{db}_{sample}.txt'
    log:
        'logs/star_trim_{db}_{sample}.log'
    shell:
        'src/star.sh {input} {output} >& {log}'

rule featurecounts:
    input:
        'data/{db}/{type}/{sample}/star/Aligned.out.sam',
    output:
        'data/{db}/{type}/{sample}/featurecounts/featurecounts.summary'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/featurecounts_{db}_{type}_{sample}.txt'
    log:
        'logs/featurecounts_{db}_{type}_{sample}.log'
    shell:
        'src/featurecounts.sh {input} {output} {wildcards.db} >& {log}'

#################################
# Alignment-free Quantification
#################################
rule salmon_count_raw:
    input:
        'data/{db}/salmon_index',
        'data/{sample}_1.fastq.gz',
        'data/{sample}_2.fastq.gz'
    output:
        'data/{db}/raw/{sample}/salmon/quant.sf'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/salmon_count_{db}_raw_{sample}.txt'
    log:
        'logs/salmon_count_{db}_raw_{sample}.log'
    shell:
        'src/salmon_count.sh {input} {wildcards.db} raw {wildcards.sample} >& {log}'

rule salmon_count_trim:
    input:
        'data/{db}/salmon_index',
        'data/{db}/trim/{sample}_1/{sample}_1_paired.fastq.gz',
        'data/{db}/trim/{sample}_2/{sample}_2_paired.fastq.gz'
    output:
        'data/{db}/trim/{sample}/salmon/quant.sf'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/salmon_count_{db}_trim_{sample}.txt'
    log:
        'logs/salmon_count_{db}_trim_{sample}.log'
    shell:
        'src/salmon_count.sh {input} {wildcards.db} trim {wildcards.sample} >& {log}'
