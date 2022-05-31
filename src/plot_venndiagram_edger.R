source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
infile4 <- commandArgs(trailingOnly=TRUE)[4]
outfile <- commandArgs(trailingOnly=TRUE)[5]

# Loading
deg_11h <- rownames(read.table(infile1))
deg_14h <- rownames(read.table(infile2))
deg_18h <- rownames(read.table(infile3))
deg_24h <- rownames(read.table(infile4))

# Venn diagram
venn.diagram(
  list(stage1=deg_11h,
    stage2=deg_14h,
      stage3=deg_18h,
      stage4=deg_24h
    ),
  filename=outfile,
  imagetype="png",
  scaled=TRUE,
  fill=1:4,
  alpha=rep(0.45, 4),
  cat.cex=1.2,
  margin=0.182
)
