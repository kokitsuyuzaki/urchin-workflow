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
STAGES = ['11h', '14h', '18h', '24h']
DEGMETHODS = ['edger', 'deseq2']

rule all:
    input:
        expand('plot/heatmap/FeatureCounts_{db1}_{type}.png',
            db1=DBS1, type=TYPES),
        expand('plot/heatmap/SalmonCounts_{db2}_{type}.png',
            db2=DBS2, type=TYPES),
        expand('plot/heatmap/SalmonTPMs_{db2}_{type}.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/FeatureCounts_{db1}_{type}_coordinates.png',
            db1=DBS1, type=TYPES),
        expand('plot/pca/FeatureCounts_{db1}_{type}_coordinates_wo_2cells.png',
            db1=DBS1, type=TYPES),
        expand('plot/pca/SalmonCounts_{db2}_{type}_coordinates.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonCounts_{db2}_{type}_coordinates_wo_2cells.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonTPMs_{db2}_{type}_coordinates.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonTPMs_{db2}_{type}_coordinates_wo_2cells.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/FeatureCounts_{db1}_{type}_scatter.png',
            db1=DBS1, type=TYPES),
        expand('plot/pca/FeatureCounts_{db1}_{type}_scatter_wo_2cells.png',
            db1=DBS1, type=TYPES),
        expand('plot/pca/SalmonCounts_{db2}_{type}_scatter.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonCounts_{db2}_{type}_scatter_wo_2cells.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonTPMs_{db2}_{type}_scatter.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonTPMs_{db2}_{type}_scatter_wo_2cells.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/FeatureCounts_{db1}_{type}_scatter_w_barycenter.png',
            db1=DBS1, type=TYPES),
        expand('plot/pca/FeatureCounts_{db1}_{type}_scatter_wo_2cells_w_barycenter.png',
            db1=DBS1, type=TYPES),
        expand('plot/pca/SalmonCounts_{db2}_{type}_scatter_w_barycenter.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonCounts_{db2}_{type}_scatter_wo_2cells_w_barycenter.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonTPMs_{db2}_{type}_scatter_w_barycenter.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonTPMs_{db2}_{type}_scatter_wo_2cells_w_barycenter.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/FeatureCounts_{db1}_{type}_scatter_no_exp_genes.png',
            db1=DBS1, type=TYPES),
        expand('plot/pca/FeatureCounts_{db1}_{type}_scatter_no_exp_genes.png',
            db1=DBS1, type=TYPES),
        expand('plot/pca/FeatureCounts_{db1}_{type}_scatter_wo_2cells_no_exp_genes.png',
            db1=DBS1, type=TYPES),
        expand('plot/pca/SalmonCounts_{db2}_{type}_scatter_no_exp_genes.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonCounts_{db2}_{type}_scatter_wo_2cells_no_exp_genes.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonTPMs_{db2}_{type}_scatter_no_exp_genes.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonTPMs_{db2}_{type}_scatter_wo_2cells_no_exp_genes.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/{counts}_{db1}_{type}_scatter_mapping_rate.png',
            counts=COUNTS, db1=DBS1, type=TYPES),
        expand('plot/pca/{counts}_{db1}_{type}_scatter_wo_2cells_mapping_rate.png',
            counts=COUNTS, db1=DBS1, type=TYPES),
        expand('plot/pca/FeatureCounts_{db1}_{type}_variance.png',
            db1=DBS1, type=TYPES),
        expand('plot/pca/FeatureCounts_{db1}_{type}_variance_wo_2cells.png',
            db1=DBS1, type=TYPES),
        expand('plot/pca/SalmonCounts_{db2}_{type}_variance.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonCounts_{db2}_{type}_variance_wo_2cells.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonTPMs_{db2}_{type}_variance.png',
            db2=DBS2, type=TYPES),
        expand('plot/pca/SalmonTPMs_{db2}_{type}_variance_wo_2cells.png',
            db2=DBS2, type=TYPES),
        expand("plot/{deg}/MAplot_{stage}.png",
            deg=DEGMETHODS,
            stage=STAGES),
        expand("plot/{deg}/Barplot.png",
            deg=DEGMETHODS),
        expand("plot/{deg}/VennDiagram.png",
            deg=DEGMETHODS),
        "output/deg/edgeR.xlsx",
        "output/deg/DESeq2.xlsx"

#################################
# Plot
#################################
rule heatmap_featurecounts:
    input:
        expand("output/FeatureCounts_{db1}_{type}.txt",
            counts=COUNTS, db1=DBS1, type=TYPES)
    output:
        'plot/heatmap/FeatureCounts_{db1}_{type}.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/heatmap_FeatureCounts_{db1}_{type}.txt'
    log:
        'logs/heatmap_FeatureCounts_{db1}_{type}.log'
    shell:
        'src/heatmap.sh FeatureCounts {wildcards.db1} {wildcards.type} {output} >& {log}'

rule heatmap_salmoncounts:
    input:
        expand("output/SalmonCounts_{db2}_{type}.txt",
            counts=COUNTS, db2=DBS2, type=TYPES)
    output:
        'plot/heatmap/SalmonCounts_{db2}_{type}.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/heatmap_SalmonCounts_{db2}_{type}.txt'
    log:
        'logs/heatmap_SalmonCounts_{db2}_{type}.log'
    shell:
        'src/heatmap.sh SalmonCounts {wildcards.db2} {wildcards.type} {output} >& {log}'

rule heatmap_salmontpms:
    input:
        expand("output/SalmonTPMs_{db2}_{type}.txt",
            counts=COUNTS, db2=DBS2, type=TYPES)
    output:
        'plot/heatmap/SalmonTPMs_{db2}_{type}.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/heatmap_SalmonTPMs_{db2}_{type}.txt'
    log:
        'logs/heatmap_SalmonTPMs_{db2}_{type}.log'
    shell:
        'src/heatmap.sh SalmonTPMs {wildcards.db2} {wildcards.type} {output} >& {log}'

rule plot_pca_coordinates_featurecounts:
    input:
        expand('output/pca/FeatureCounts_{db1}_{type}_coordinates.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_coordinates_wo_2cells.csv',
            db1=DBS1, type=TYPES)
    output:
        'plot/pca/FeatureCounts_{db1}_{type}_coordinates.png',
        'plot/pca/FeatureCounts_{db1}_{type}_coordinates_wo_2cells.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_coordinates_FeatureCounts_{db1}_{type}.txt'
    log:
        'logs/plot_pca_coordinates_FeatureCounts_{db1}_{type}.log'
    shell:
        'src/plot_pca_coordinates.sh FeatureCounts {wildcards.db1} {wildcards.type} {output} >& {log}'

rule plot_pca_coordinates_salmoncounts:
    input:
        expand('output/pca/SalmonCounts_{db2}_{type}_coordinates.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_coordinates_wo_2cells.csv',
            db2=DBS2, type=TYPES)
    output:
        'plot/pca/SalmonCounts_{db2}_{type}_coordinates.png',
        'plot/pca/SalmonCounts_{db2}_{type}_coordinates_wo_2cells.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_coordinates_SalmonCounts_{db2}_{type}.txt'
    log:
        'logs/plot_pca_coordinates_SalmonCounts_{db2}_{type}.log'
    shell:
        'src/plot_pca_coordinates.sh SalmonCounts {wildcards.db2} {wildcards.type} {output} >& {log}'

rule plot_pca_coordinates_salmontpms:
    input:
        expand('output/pca/SalmonTPMs_{db2}_{type}_coordinates.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_coordinates_wo_2cells.csv',
            db2=DBS2, type=TYPES)
    output:
        'plot/pca/SalmonTPMs_{db2}_{type}_coordinates.png',
        'plot/pca/SalmonTPMs_{db2}_{type}_coordinates_wo_2cells.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_coordinates_SalmonTPMs_{db2}_{type}.txt'
    log:
        'logs/plot_pca_coordinates_SalmonTPMs_{db2}_{type}.log'
    shell:
        'src/plot_pca_coordinates.sh SalmonTPMs {wildcards.db2} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter_featurecounts:
    input:
        expand('output/pca/FeatureCounts_{db1}_{type}_coordinates.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_variance.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_coordinates_wo_2cells.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_variance_wo_2cells.csv',
            db1=DBS1, type=TYPES)
    output:
        'plot/pca/FeatureCounts_{db1}_{type}_scatter.png',
        'plot/pca/FeatureCounts_{db1}_{type}_scatter_wo_2cells.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_FeatureCounts_{db1}_{type}.txt'
    log:
        'logs/plot_pca_scatter_FeatureCounts_{db1}_{type}.log'
    shell:
        'src/plot_pca_scatter.sh FeatureCounts {wildcards.db1} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter_salmoncounts:
    input:
        expand('output/pca/SalmonCounts_{db2}_{type}_coordinates.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_variance.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_coordinates_wo_2cells.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_variance_wo_2cells.csv',
            db2=DBS2, type=TYPES)
    output:
        'plot/pca/SalmonCounts_{db2}_{type}_scatter.png',
        'plot/pca/SalmonCounts_{db2}_{type}_scatter_wo_2cells.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_SalmonCounts_{db2}_{type}.txt'
    log:
        'logs/plot_pca_scatter_SalmonCounts_{db2}_{type}.log'
    shell:
        'src/plot_pca_scatter.sh SalmonCounts {wildcards.db2} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter_salmontpms:
    input:
        expand('output/pca/SalmonTPMs_{db2}_{type}_coordinates.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_variance.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_coordinates_wo_2cells.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_variance_wo_2cells.csv',
            db2=DBS2, type=TYPES)
    output:
        'plot/pca/SalmonTPMs_{db2}_{type}_scatter.png',
        'plot/pca/SalmonTPMs_{db2}_{type}_scatter_wo_2cells.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_SalmonTPMs_{db2}_{type}.txt'
    log:
        'logs/plot_pca_scatter_SalmonTPMs_{db2}_{type}.log'
    shell:
        'src/plot_pca_scatter.sh SalmonTPMs {wildcards.db2} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter_w_barycenter_featurecounts:
    input:
        expand('output/pca/FeatureCounts_{db1}_{type}_coordinates.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_variance.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_coordinates_wo_2cells.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_variance_wo_2cells.csv',
            db1=DBS1, type=TYPES)
    output:
        'plot/pca/FeatureCounts_{db1}_{type}_scatter_w_barycenter.png',
        'plot/pca/FeatureCounts_{db1}_{type}_scatter_wo_2cells_w_barycenter.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_w_barycenter_FeatureCounts_{db1}_{type}.txt'
    log:
        'logs/plot_pca_scatter_w_barycenter_FeatureCounts_{db1}_{type}.log'
    shell:
        'src/plot_pca_scatter_w_barycenter.sh FeatureCounts {wildcards.db1} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter_w_barycenter_salmoncounts:
    input:
        expand('output/pca/SalmonCounts_{db2}_{type}_coordinates.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_variance.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_coordinates_wo_2cells.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_variance_wo_2cells.csv',
            db2=DBS2, type=TYPES)
    output:
        'plot/pca/SalmonCounts_{db2}_{type}_scatter_w_barycenter.png',
        'plot/pca/SalmonCounts_{db2}_{type}_scatter_wo_2cells_w_barycenter.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_w_barycenter_SalmonCounts_{db2}_{type}.txt'
    log:
        'logs/plot_pca_scatter_w_barycenter_SalmonCounts_{db2}_{type}.log'
    shell:
        'src/plot_pca_scatter_w_barycenter.sh SalmonCounts {wildcards.db2} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter_w_barycenter_salmontpms:
    input:
        expand('output/pca/SalmonTPMs_{db2}_{type}_coordinates.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_variance.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_coordinates_wo_2cells.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_variance_wo_2cells.csv',
            db2=DBS2, type=TYPES)
    output:
        'plot/pca/SalmonTPMs_{db2}_{type}_scatter_w_barycenter.png',
        'plot/pca/SalmonTPMs_{db2}_{type}_scatter_wo_2cells_w_barycenter.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_w_barycenter_SalmonTPMs_{db2}_{type}.txt'
    log:
        'logs/plot_pca_scatter_w_barycenter_SalmonTPMs_{db2}_{type}.log'
    shell:
        'src/plot_pca_scatter_w_barycenter.sh SalmonTPMs {wildcards.db2} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter_no_exp_genes_featurecounts:
    input:
        expand('output/pca/FeatureCounts_{db1}_{type}_coordinates.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_variance.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_coordinates_wo_2cells.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_variance_wo_2cells.csv',
            db1=DBS1, type=TYPES)
    output:
        'plot/pca/FeatureCounts_{db1}_{type}_scatter_no_exp_genes.png',
        'plot/pca/FeatureCounts_{db1}_{type}_scatter_wo_2cells_no_exp_genes.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_no_exp_genes_FeatureCounts_{db1}_{type}.txt'
    log:
        'logs/plot_pca_scatter_no_exp_genes_FeatureCounts_{db1}_{type}.log'
    shell:
        'src/plot_pca_scatter_no_exp_genes.sh FeatureCounts {wildcards.db1} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter_no_exp_genes_salmoncounts:
    input:
        expand('output/pca/SalmonCounts_{db2}_{type}_coordinates.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_variance.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_coordinates_wo_2cells.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_variance_wo_2cells.csv',
            db2=DBS2, type=TYPES)
    output:
        'plot/pca/SalmonCounts_{db2}_{type}_scatter_no_exp_genes.png',
        'plot/pca/SalmonCounts_{db2}_{type}_scatter_wo_2cells_no_exp_genes.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_no_exp_genes_SalmonCounts_{db2}_{type}.txt'
    log:
        'logs/plot_pca_scatter_no_exp_genes_SalmonCounts_{db2}_{type}.log'
    shell:
        'src/plot_pca_scatter_no_exp_genes.sh SalmonCounts {wildcards.db2} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter_no_exp_genes_salmontpms:
    input:
        expand('output/pca/SalmonTPMs_{db2}_{type}_coordinates.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_variance.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_coordinates_wo_2cells.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_variance_wo_2cells.csv',
            db2=DBS2, type=TYPES)
    output:
        'plot/pca/SalmonTPMs_{db2}_{type}_scatter_no_exp_genes.png',
        'plot/pca/SalmonTPMs_{db2}_{type}_scatter_wo_2cells_no_exp_genes.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_no_exp_genes_SalmonTPMs_{db2}_{type}.txt'
    log:
        'logs/plot_pca_scatter_no_exp_genes_SalmonTPMs_{db2}_{type}.log'
    shell:
        'src/plot_pca_scatter_no_exp_genes.sh SalmonTPMs {wildcards.db2} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter_mapping_rate:
    input:
        expand('data/{db1}/{type}/mapping_rate.txt',
            db1=DBS1, type=TYPES),
        expand('output/pca/{counts}_{db1}_{type}_coordinates.csv',
            counts=COUNTS, db1=DBS1, type=TYPES),
        expand('output/pca/{counts}_{db1}_{type}_variance.csv',
            counts=COUNTS, db1=DBS1, type=TYPES),
        expand('output/pca/{counts}_{db1}_{type}_coordinates_wo_2cells.csv',
            counts=COUNTS, db1=DBS1, type=TYPES),
        expand('output/pca/{counts}_{db1}_{type}_variance_wo_2cells.csv',
            counts=COUNTS, db1=DBS1, type=TYPES)
    output:
        'plot/pca/{counts}_{db1}_{type}_scatter_mapping_rate.png',
        'plot/pca/{counts}_{db1}_{type}_scatter_wo_2cells_mapping_rate.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_mapping_rate_{counts}_{db1}_{type}.txt'
    log:
        'logs/plot_pca_scatter_mapping_rate_{counts}_{db1}_{type}.log'
    shell:
        'src/plot_pca_scatter_mapping_rate.sh {wildcards.counts} {wildcards.db1} {wildcards.type} {output} >& {log}'

rule plot_pca_variance_featurecounts:
    input:
        expand('output/pca/FeatureCounts_{db1}_{type}_variance.csv',
            db1=DBS1, type=TYPES),
        expand('output/pca/FeatureCounts_{db1}_{type}_variance_wo_2cells.csv',
            db1=DBS1, type=TYPES)
    output:
        'plot/pca/FeatureCounts_{db1}_{type}_variance.png',
        'plot/pca/FeatureCounts_{db1}_{type}_variance_wo_2cells.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_variance_FeatureCounts_{db1}_{type}.txt'
    log:
        'logs/plot_pca_variance_FeatureCounts_{db1}_{type}.log'
    shell:
        'src/plot_pca_variance.sh FeatureCounts {wildcards.db1} {wildcards.type} {output} >& {log}'

rule plot_pca_variance_salmoncounts:
    input:
        expand('output/pca/SalmonCounts_{db2}_{type}_variance.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonCounts_{db2}_{type}_variance_wo_2cells.csv',
            db2=DBS2, type=TYPES)
    output:
        'plot/pca/SalmonCounts_{db2}_{type}_variance.png',
        'plot/pca/SalmonCounts_{db2}_{type}_variance_wo_2cells.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_variance_SalmonCounts_{db2}_{type}.txt'
    log:
        'logs/plot_pca_variance_SalmonCounts_{db2}_{type}.log'
    shell:
        'src/plot_pca_variance.sh SalmonCounts {wildcards.db2} {wildcards.type} {output} >& {log}'

rule plot_pca_variance_salmontpms:
    input:
        expand('output/pca/SalmonTPMs_{db2}_{type}_variance.csv',
            db2=DBS2, type=TYPES),
        expand('output/pca/SalmonTPMs_{db2}_{type}_variance_wo_2cells.csv',
            db2=DBS2, type=TYPES)
    output:
        'plot/pca/SalmonTPMs_{db2}_{type}_variance.png',
        'plot/pca/SalmonTPMs_{db2}_{type}_variance_wo_2cells.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_variance_SalmonTPMs_{db2}_{type}.txt'
    log:
        'logs/plot_pca_variance_SalmonTPMs_{db2}_{type}.log'
    shell:
        'src/plot_pca_variance.sh SalmonTPMs {wildcards.db2} {wildcards.type} {output} >& {log}'

rule plot_maplot_edger:
    input:
        "output/deg/edger/FeatureCounts_hpbase_trim_{stage}.RData",
        "output/deg/edger/FeatureCounts_hpbase_trim_{stage}_all.txt",
        "output/deg/edger/FeatureCounts_hpbase_trim_{stage}_deg.txt"
    output:
        "plot/edger/MAplot_{stage}.png"
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_maplot_edger_{stage}.txt'
    log:
        'logs/plot_maplot_edger_{stage}.log'
    shell:
        'src/plot_maplot_edger.sh {input} {output} >& {log}'

rule plot_maplot_deseq2:
    input:
        "output/deg/deseq2/FeatureCounts_hpbase_trim_{stage}.RData",
        "output/deg/deseq2/FeatureCounts_hpbase_trim_{stage}_all.txt",
        "output/deg/deseq2/FeatureCounts_hpbase_trim_{stage}_deg.txt"
    output:
        "plot/deseq2/MAplot_{stage}.png"
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_maplot_deseq2_{stage}.txt'
    log:
        'logs/plot_maplot_deseq2_{stage}.log'
    shell:
        'src/plot_maplot_deseq2.sh {input} {output} >& {log}'

rule plot_barplot_edger:
    input:
        expand("output/deg/edger/FeatureCounts_hpbase_trim_{stage}_deg.txt",
            stage=STAGES)
    output:
        "plot/edger/Barplot.png"
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_barplot_edger.txt'
    log:
        'logs/plot_barplot_edger.log'
    shell:
        'src/plot_barplot_edger.sh {input} {output} >& {log}'

rule plot_barplot_deseq2:
    input:
        expand("output/deg/deseq2/FeatureCounts_hpbase_trim_{stage}_deg.txt",
            stage=STAGES)
    output:
        "plot/deseq2/Barplot.png"
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_barplot_deseq2.txt'
    log:
        'logs/plot_barplot_deseq2.log'
    shell:
        'src/plot_barplot_deseq2.sh {input} {output} >& {log}'

rule plot_venndiagram_edger:
    input:
        expand("output/deg/edger/FeatureCounts_hpbase_trim_{stage}_deg.txt",
            stage=STAGES)
    output:
        "plot/edger/VennDiagram.png"
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_venndiagram_edger.txt'
    log:
        'logs/plot_venndiagram_edger.log'
    shell:
        'src/plot_venndiagram_edger.sh {input} {output} >& {log}'

rule plot_venndiagram_deseq2:
    input:
        expand("output/deg/deseq2/FeatureCounts_hpbase_trim_{stage}_deg.txt",
            stage=STAGES)
    output:
        "plot/deseq2/VennDiagram.png"
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_venndiagram_deseq2.txt'
    log:
        'logs/plot_venndiagram_deseq2.log'
    shell:
        'src/plot_venndiagram_deseq2.sh {input} {output} >& {log}'

rule xlsx_edger:
    input:
        expand("output/deg/edger/FeatureCounts_hpbase_trim_{stage}_deg.txt",
            stage=STAGES)
    output:
        "output/deg/edgeR.xlsx"
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/xlsx_edger.txt'
    log:
        'logs/xlsx_edger.log'
    shell:
        'src/xlsx_edger.sh {input} {output} >& {log}'

rule xlsx_deseq2:
    input:
        expand("output/deg/deseq2/FeatureCounts_hpbase_trim_{stage}_deg.txt",
            stage=STAGES)
    output:
        "output/deg/DESeq2.xlsx"
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/xlsx_deseq2.txt'
    log:
        'logs/xlsx_deseq2.log'
    shell:
        'src/xlsx_deseq2.sh {input} {output} >& {log}'
