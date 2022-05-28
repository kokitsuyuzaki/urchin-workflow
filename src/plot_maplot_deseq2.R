source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[3]
outfile <- commandArgs(trailingOnly=TRUE)[4]

# Loading
load(infile1)
deg <- read.table(infile2)

# Plot
png(file=outfile, width=700, height=700)
par(ps=24)
plotMA(res, alpha=0.1)
dev.off()
