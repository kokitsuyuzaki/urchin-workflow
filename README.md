# urchin-workflow
This workflow consists of five workflows as follows:
- **workflow/download.smk**: Data downloading
![](https://github.com/kokitsuyuzaki/urchin-workflow/blob/master/plot/download.png?raw=true)
-  **workflow/qc.smk**: Data quality check
![](https://github.com/kokitsuyuzaki/urchin-workflow/blob/master/plot/qc.png?raw=true)
- **workflow/index.smk**: Indexing of genome and transcriptome sequences
![](https://github.com/kokitsuyuzaki/urchin-workflow/blob/master/plot/index.png?raw=true)
- **workflow/quantification.smk**: Reference-based/free quantification
![](https://github.com/kokitsuyuzaki/urchin-workflow/blob/master/plot/quantification.png?raw=true)
- **workflow/summary.smk**: Summary of the data analysis
![](https://github.com/kokitsuyuzaki/urchin-workflow/blob/master/plot/summary.png?raw=true)
- **workflow/plot.smk**: Visualization
![](https://github.com/kokitsuyuzaki/urchin-workflow/blob/master/plot/plot.png?raw=true)

## Requirements
- Bash: GNU bash, version 4.2.46(1)-release (x86_64-redhat-linux-gnu)
- Snakemake: 6.5.3
- Singularity: 3.5.3

## How to reproduce this workflow
### In Local Machine

```
snakemake -s workflow/download.smk -j 4 --use-singularity
snakemake -s workflow/qc.smk -j 4 --use-singularity
snakemake -s workflow/index.smk -j 4 --use-singularity
snakemake -s workflow/quantification.smk -j 4 --use-singularity
snakemake -s workflow/summary -j 4 --use-singularity
snakemake -s workflow/plot.smk -j 4 --use-singularity
```

### In Open Grid Engine

```
snakemake -s workflow/download.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/qc.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/index.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/quantification.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/summary -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/plot.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
```

### In Slurm

```
snakemake -s workflow/download.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/qc.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/index.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/quantification.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/summary -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/plot.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
```

## License
Copyright (c) 2022 Koki Tsuyuzaki released under the [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

## Authors
- Koki Tsuyuzaki
- Shunsuke Yaguchi