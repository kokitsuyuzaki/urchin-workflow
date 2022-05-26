import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

URCHIN_SAMPLES, = glob_wildcards('data/{sample}_1.fastq.gz')

rule all:
    input:
        expand('data/{db}/{type}/{sample}/Aligned.out.sam',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw'],
            sample=URCHIN_SAMPLES),
        expand('data/{db}/{type}/{sample}/quant.sf',
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
        'data/{db}/raw/{sample}/Aligned.out.sam'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/star_raw_{db}_{sample}.txt'
    log:
        'logs/star_raw_{db}_{sample}.log'
    shell:
        'src/star.sh {input} {wildcards.sample} >& {log}'

rule star_trim:
    input:
        'data/{db}/star_index',
        'data/{db}/trim/{sample}_1_paired.fastq.gz',
        'data/{db}/trim/{sample}_2_paired.fastq.gz'
    output:
        'data/{db}/trim/{sample}/Aligned.out.sam'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/star_trim_{db}_{sample}.txt'
    log:
        'logs/star_trim_{db}_{sample}.log'
    shell:
        'src/star.sh {input} {wildcards.sample} >& {log}'

# rule featurecounts:
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
#         'src/featurecounts.sh >& {log}'

#################################
# Alignment-free Quantification
#################################
rule salmon_count_raw:
    input:
        'data/{db}/salmon_index',
        'data/{sample}_1.fastq.gz',
        'data/{sample}_2.fastq.gz'
    output:
        'data/{db}/raw/{sample}/quant.sf'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/salmon_count_{db}_{sample}.txt'
    log:
        'logs/salmon_count_{db}_{sample}.log'
    shell:
        'src/salmon_count.sh {input} {wildcards.db} raw {wildcards.sample} >& {log}'

rule salmon_count_trim:
    input:
        'data/{db}/salmon_index',
        'data/{db}/trim/{sample}_1_paired.fastq.gz',
        'data/{db}/trim/{sample}_2_paired.fastq.gz'
    output:
        'data/{db}/trim/{sample}/quant.sf'
    resources:
        mem_gb=100
    container:
        'docker://koki/urchin_workflow_bioconda:20220525'
    benchmark:
        'benchmarks/salmon_count_{db}_{sample}.txt'
    log:
        'logs/salmon_count_{db}_{sample}.log'
    shell:
        'src/salmon_count.sh {input} {wildcards.db} trim {wildcards.sample} >& {log}'
