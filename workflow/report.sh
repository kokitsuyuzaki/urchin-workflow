# HTML
mkdir -p report
snakemake -s workflow/download.smk --report report/download.html
snakemake -s workflow/qc.smk --report report/qc.html
snakemake -s workflow/index.smk --report report/index.html
snakemake -s workflow/quantification.smk --report report/quantification.html
snakemake -s workflow/summary.smk --report report/summary.html
snakemake -s workflow/plot.smk --report report/plot.html
