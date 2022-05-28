source("src/Functions.R")

# Parameter
db <- commandArgs(trailingOnly=TRUE)[1]
type <- commandArgs(trailingOnly=TRUE)[2]
outfile1 <- commandArgs(trailingOnly=TRUE)[3]
outfile2 <- commandArgs(trailingOnly=TRUE)[4]

# Preprocess
infile <- paste0("output/FeatureCounts_", db, "_", type, ".txt")
mat <- read.delim(infile, skip=1)
row_names <- mat[,1]
mat <- as.matrix(mat[, 7:33])
rownames(mat) <- row_names

# PCA
res_pca <- prcomp(t(log10(mat+1)), center=TRUE)
exprained <- res_pca$sdev^2
exprained <- exprained / sum(exprained)

# Save
write.table(res_pca$x, outfile1)
write.table(exprained, outfile2)
