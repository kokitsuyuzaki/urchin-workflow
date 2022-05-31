source("src/Functions.R")

# Parameter
db <- commandArgs(trailingOnly=TRUE)[1]
type <- commandArgs(trailingOnly=TRUE)[2]
outfile1 <- commandArgs(trailingOnly=TRUE)[3]
outfile2 <- commandArgs(trailingOnly=TRUE)[4]
outfile3 <- commandArgs(trailingOnly=TRUE)[5]
outfile4 <- commandArgs(trailingOnly=TRUE)[6]

# Loading
infile <- paste0("output/FeatureCounts_", db, "_", type, ".txt")
mat <- read.delim(infile, skip=1)

# Preprocessing
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

# Preprocessing
mat_2 <- mat[, 1:24]

# PCA
res_pca_2 <- prcomp(t(log10(mat_2+1)), center=TRUE)
exprained_2 <- res_pca_2$sdev^2
exprained_2 <- exprained_2 / sum(exprained_2)

# Save
write.table(res_pca_2$x, outfile3)
write.table(exprained_2, outfile4)
