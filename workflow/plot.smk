import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("6.5.3")

container: 'docker://koki/urchin_workflow_r:20220531'

COUNTS = ['FeatureCounts', 'SalmonCounts', 'SalmonTPMs']
DBS = ['hpbase', 'echinobase']
TYPES = ['raw', 'trim']
STAGES = ['11h', '14h', '18h', '24h']
DEGMETHODS = ['edger', 'deseq2']

rule all:
    input:
        expand('plot/heatmap/{counts}_{db}_{type}.png',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('plot/pca/{counts}_{db}_{type}_coordinates.png',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('plot/pca/{counts}_{db}_{type}_scatter.png',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('plot/pca/{counts}_{db}_{type}_scatter_w_barycenter.png',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('plot/pca/{counts}_{db}_{type}_scatter_no_exp_genes.png',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('plot/pca/{counts}_{db}_{type}_scatter_mapping_rate.png',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('plot/pca/{counts}_{db}_{type}_variance.png',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('plot/pca/{counts}_{db}_{type}_coordinates_wo_2cells.png',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('plot/pca/{counts}_{db}_{type}_scatter_wo_2cells.png',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('plot/pca/{counts}_{db}_{type}_scatter_wo_2cells_no_exp_genes.png',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('plot/pca/{counts}_{db}_{type}_scatter_wo_2cells_mapping_rate.png',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('plot/pca/{counts}_{db}_{type}_scatter_wo_2cells_w_barycenter.png',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('plot/pca/{counts}_{db}_{type}_variance_wo_2cells.png',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand("plot/edger/MAplot_{stage}.png",
            stage=STAGES),
        expand("plot/deseq2/MAplot_{stage}.png",
            stage=STAGES),
        "plot/edger/Barplot.png",
        "plot/deseq2/Barplot.png",
        "plot/edger/VennDiagram.png",
        "plot/deseq2/VennDiagram.png",
        "output/deg/edgeR.xlsx",
        "output/deg/DESeq2.xlsx"

#################################
# DEGs, Plots, Reports ... etc
#################################
rule heatmap:
    input:
        expand("output/{counts}_{db}_{type}.txt",
            counts=COUNTS,
            db=DBS,
            type=TYPES)
    output:
        'plot/heatmap/{counts}_{db}_{type}.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/heatmap_{counts}_{db}_{type}.txt'
    log:
        'logs/heatmap_{counts}_{db}_{type}.log'
    shell:
        'src/heatmap.sh {wildcards.counts} {wildcards.db} {wildcards.type} {output} >& {log}'

rule pca_featurecounts:
    input:
        expand("output/FeatureCounts_{db}_{type}.txt",
            db=DBS,
            type=TYPES)
    output:
        'output/pca/FeatureCounts_{db}_{type}_coordinates.csv',
        'output/pca/FeatureCounts_{db}_{type}_variance.csv',
        'output/pca/FeatureCounts_{db}_{type}_coordinates_wo_2cells.csv',
        'output/pca/FeatureCounts_{db}_{type}_variance_wo_2cells.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/pca_featurecounts_{db}_{type}.txt'
    log:
        'logs/pca_featurecounts_{db}_{type}.log'
    shell:
        'src/pca_featurecounts.sh {wildcards.db} {wildcards.type} {output} >& {log}'

rule pca_salmoncounts:
    input:
        expand("output/SalmonCounts_{db}_{type}.txt",
            db=DBS,
            type=TYPES)
    output:
        'output/pca/SalmonCounts_{db}_{type}_coordinates.csv',
        'output/pca/SalmonCounts_{db}_{type}_variance.csv',
        'output/pca/SalmonCounts_{db}_{type}_coordinates_wo_2cells.csv',
        'output/pca/SalmonCounts_{db}_{type}_variance_wo_2cells.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/pca_salmoncounts_{db}_{type}.txt'
    log:
        'logs/pca_salmoncounts_{db}_{type}.log'
    shell:
        'src/pca_salmoncounts.sh {wildcards.db} {wildcards.type} {output} >& {log}'

rule pca_salmontpms:
    input:
        expand("output/SalmonTPMs_{db}_{type}.txt",
            db=DBS,
            type=TYPES)
    output:
        'output/pca/SalmonTPMs_{db}_{type}_coordinates.csv',
        'output/pca/SalmonTPMs_{db}_{type}_variance.csv',
        'output/pca/SalmonTPMs_{db}_{type}_coordinates_wo_2cells.csv',
        'output/pca/SalmonTPMs_{db}_{type}_variance_wo_2cells.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/pca_salmontpms_{db}_{type}.txt'
    log:
        'logs/pca_salmontpms_{db}_{type}.log'
    shell:
        'src/pca_salmontpms.sh {wildcards.db} {wildcards.type} {output} >& {log}'

rule plot_pca_coordinates:
    input:
        expand('output/pca/{counts}_{db}_{type}_coordinates.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_coordinates_wo_2cells.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES)
    output:
        'plot/pca/{counts}_{db}_{type}_coordinates.png',
        'plot/pca/{counts}_{db}_{type}_coordinates_wo_2cells.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_coordinates_{counts}_{db}_{type}.txt'
    log:
        'logs/plot_pca_coordinates_{counts}_{db}_{type}.log'
    shell:
        'src/plot_pca_coordinates.sh {wildcards.counts} {wildcards.db} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter:
    input:
        expand('output/pca/{counts}_{db}_{type}_coordinates.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_variance.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_coordinates_wo_2cells.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_variance_wo_2cells.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES)
    output:
        'plot/pca/{counts}_{db}_{type}_scatter.png',
        'plot/pca/{counts}_{db}_{type}_scatter_wo_2cells.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_{counts}_{db}_{type}.txt'
    log:
        'logs/plot_pca_scatter_{counts}_{db}_{type}.log'
    shell:
        'src/plot_pca_scatter.sh {wildcards.counts} {wildcards.db} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter_w_barycenter:
    input:
        expand('output/pca/{counts}_{db}_{type}_coordinates.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_variance.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_coordinates_wo_2cells.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_variance_wo_2cells.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES)
    output:
        'plot/pca/{counts}_{db}_{type}_scatter_w_barycenter.png',
        'plot/pca/{counts}_{db}_{type}_scatter_wo_2cells_w_barycenter.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_w_barycenter_{counts}_{db}_{type}.txt'
    log:
        'logs/plot_pca_scatter_w_barycenter_{counts}_{db}_{type}.log'
    shell:
        'src/plot_pca_scatter_w_barycenter.sh {wildcards.counts} {wildcards.db} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter_no_exp_genes:
    input:
        expand('output/pca/{counts}_{db}_{type}_coordinates.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_variance.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_coordinates_wo_2cells.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_variance_wo_2cells.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES)
    output:
        'plot/pca/{counts}_{db}_{type}_scatter_no_exp_genes.png',
        'plot/pca/{counts}_{db}_{type}_scatter_wo_2cells_no_exp_genes.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_no_exp_genes_{counts}_{db}_{type}.txt'
    log:
        'logs/plot_pca_scatter_no_exp_genes_{counts}_{db}_{type}.log'
    shell:
        'src/plot_pca_scatter_no_exp_genes.sh {wildcards.counts} {wildcards.db} {wildcards.type} {output} >& {log}'

rule plot_pca_scatter_mapping_rate:
    input:
        expand('data/{db}/{type}/mapping_rate.txt',
            db=['hpbase', 'echinobase'],
            type=['trim', 'raw']),
        expand('output/pca/{counts}_{db}_{type}_coordinates.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_variance.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_coordinates_wo_2cells.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_variance_wo_2cells.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES)
    output:
        'plot/pca/{counts}_{db}_{type}_scatter_mapping_rate.png',
        'plot/pca/{counts}_{db}_{type}_scatter_wo_2cells_mapping_rate.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_scatter_mapping_rate_{counts}_{db}_{type}.txt'
    log:
        'logs/plot_pca_scatter_mapping_rate_{counts}_{db}_{type}.log'
    shell:
        'src/plot_pca_scatter_mapping_rate.sh {wildcards.counts} {wildcards.db} {wildcards.type} {output} >& {log}'

rule plot_pca_variance:
    input:
        expand('output/pca/{counts}_{db}_{type}_variance.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES),
        expand('output/pca/{counts}_{db}_{type}_variance_wo_2cells.csv',
            counts=COUNTS,
            db=DBS,
            type=TYPES)
    output:
        'plot/pca/{counts}_{db}_{type}_variance.png',
        'plot/pca/{counts}_{db}_{type}_variance_wo_2cells.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_pca_variance_{counts}_{db}_{type}.txt'
    log:
        'logs/plot_pca_variance_{counts}_{db}_{type}.log'
    shell:
        'src/plot_pca_variance.sh {wildcards.counts} {wildcards.db} {wildcards.type} {output} >& {log}'

rule deg_edger:
    input:
        "output/SalmonCounts_hpbase_trim.txt"
    output:
        "output/deg/edger_{stage}.RData",
        "output/deg/edger_{stage}_all.txt",
        "output/deg/edger_{stage}_deg.txt"
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/deg_edger_{stage}.txt'
    log:
        'logs/deg_edger_{stage}.log'
    shell:
        'src/deg_edger.sh {input} {output} {wildcards.stage} >& {log}'

rule deg_deseq2:
    input:
        "output/SalmonCounts_hpbase_trim.txt"
    output:
        "output/deg/deseq2_{stage}.RData",
        "output/deg/deseq2_{stage}_all.txt",
        "output/deg/deseq2_{stage}_deg.txt"
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/deg_deseq2_{stage}.txt'
    log:
        'logs/deg_deseq2_{stage}.log'
    shell:
        'src/deg_deseq2.sh {input} {output} {wildcards.stage} >& {log}'

rule plot_maplot_edger:
    input:
        "output/deg/edger_{stage}.RData",
        "output/deg/edger_{stage}_all.txt",
        "output/deg/edger_{stage}_deg.txt"
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
        "output/deg/deseq2_{stage}.RData",
        "output/deg/deseq2_{stage}_all.txt",
        "output/deg/deseq2_{stage}_deg.txt"
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
        expand("output/deg/edger_{stage}_deg.txt",
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

rule plot_venndiagram_edger:
    input:
        expand("output/deg/edger_{stage}_deg.txt",
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

rule plot_barplot_deseq2:
    input:
        expand("output/deg/deseq2_{stage}_deg.txt",
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

rule plot_venndiagram_deseq2:
    input:
        expand("output/deg/deseq2_{stage}_deg.txt",
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
        expand("output/deg/edger_{stage}_deg.txt",
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
        expand("output/deg/deseq2_{stage}_deg.txt",
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