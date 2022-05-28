source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile1 <- commandArgs(trailingOnly=TRUE)[2]
outfile2 <- commandArgs(trailingOnly=TRUE)[3]
outfile3 <- commandArgs(trailingOnly=TRUE)[4]
stage <- commandArgs(trailingOnly=TRUE)[5]

# Loading
count <- read.table(infile)

# Setting
group <- factor(c(rep("control", 3), rep("half", 3)))
design <- model.matrix(~ group)

# Index of corresponding samples
idx <- .sample_position[[stage]]

# edgeR
d <- DGEList(counts = count[, idx], group = group)
d <- calcNormFactors(d)
d <- estimateDisp(d, design)
fit <- glmFit(d, design)
res <- glmLRT(fit, coef=2)
all <- topTags(res, nrow(count))[[1]]
deg <- all[which(all$FDR < 0.1), ]

# Save
save(res, file=outfile1)
write.table(all, outfile2)
write.table(deg, outfile3)
