import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

container: 'docker://koki/urchin_workflow_r:20220531'

COUNTS = ['FeatureCounts', 'SalmonCounts', 'SalmonTPMs']
DBS1 = ['hpbase', 'echinobase']
DBS2 = ['hpbase', 'hpbase_nucl', 'echinobase']
TYPES = ['raw', 'trim']

rule all:
    input:
        expand('output/pca/FeatureCounts_{db1}_{type}_coordinates.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_variance.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_coordinates_wo_2cells.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_variance_wo_2cells.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_coordinates.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_variance.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_coordinates_wo_2cells.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_variance_wo_2cells.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_coordinates.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_variance.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_coordinates_wo_2cells.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_variance_wo_2cells.csv',
            db2=DBS2, type=TYPES)

#################################
# Dimension Reduction
#################################
rule pca_featurecounts:
    input:
        expand("output/FeatureCounts_{db1}_{type}.txt",
            db1=DBS1,
            type=TYPES)
    output:
        'output/pca/FeatureCounts_{db1}_{type}_coordinates.csv',
        'output/pca/FeatureCounts_{db1}_{type}_variance.csv',
        'output/pca/FeatureCounts_{db1}_{type}_coordinates_wo_2cells.csv',
        'output/pca/FeatureCounts_{db1}_{type}_variance_wo_2cells.csv'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/pca_featurecounts_{db1}_{type}.txt'
    log:
        'logs/pca_featurecounts_{db1}_{type}.log'
    shell:
        'src/pca_featurecounts.sh {wildcards.db1} {wildcards.type} {output} >& {log}'

rule pca_salmoncounts:
    input:
        expand("output/SalmonCounts_{db2}_{type}.txt",
            db2=DBS2,
            type=TYPES)
    output:
        'output/pca/SalmonCounts_{db2}_{type}_coordinates.csv',
        'output/pca/SalmonCounts_{db2}_{type}_variance.csv',
        'output/pca/SalmonCounts_{db2}_{type}_coordinates_wo_2cells.csv',
        'output/pca/SalmonCounts_{db2}_{type}_variance_wo_2cells.csv'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/pca_salmoncounts_{db2}_{type}.txt'
    log:
        'logs/pca_salmoncounts_{db2}_{type}.log'
    shell:
        'src/pca_salmoncounts.sh {wildcards.db2} {wildcards.type} {output} >& {log}'

rule pca_salmontpms:
    input:
        expand("output/SalmonTPMs_{db2}_{type}.txt",
            db2=DBS2,
            type=TYPES)
    output:
        'output/pca/SalmonTPMs_{db2}_{type}_coordinates.csv',
        'output/pca/SalmonTPMs_{db2}_{type}_variance.csv',
        'output/pca/SalmonTPMs_{db2}_{type}_coordinates_wo_2cells.csv',
        'output/pca/SalmonTPMs_{db2}_{type}_variance_wo_2cells.csv'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/pca_salmontpms_{db2}_{type}.txt'
    log:
        'logs/pca_salmontpms_{db2}_{type}.log'
    shell:
        'src/pca_salmontpms.sh {wildcards.db2} {wildcards.type} {output} >& {log}'
