# DAG graph
snakemake -s workflow/download.smk --rulegraph | dot -Tpng > plot/download.png
snakemake -s workflow/qc.smk --rulegraph | dot -Tpng > plot/qc.png
snakemake -s workflow/index.smk --rulegraph | dot -Tpng > plot/index.png
snakemake -s workflow/quantification.smk --rulegraph | dot -Tpng > plot/quantification.png
snakemake -s workflow/summary.smk --rulegraph | dot -Tpng > plot/summary.png
snakemake -s workflow/plot.smk --rulegraph | dot -Tpng > plot/plot.png
