# urchin-workflow

![](https://github.com/kokitsuyuzaki/urchin-workflow/blob/master/plot/dag.png?raw=true)

## Requirements
- Bash: GNU bash, version 4.2.46(1)-release (x86_64-redhat-linux-gnu)
- Snakemake: 6.5.3
- Singularity: 3.5.3

## How to reproduce this workflow

```
snakemake -j 4 --use-singularity # Local Machine
snakemake -j 32 --cluster qsub --latency-wait 600 --use-singularity # Open Grid Engine
snakemake -j 32 --cluster sbatch --latency-wait 600 --use-singularity # Slurm
```

## License
Copyright (c) 2022 Koki Tsuyuzaki released under the [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

## Authors
- Koki Tsuyuzaki
- Shunsuke Yaguchi