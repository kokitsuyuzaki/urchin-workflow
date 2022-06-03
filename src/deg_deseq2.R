source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile1 <- commandArgs(trailingOnly=TRUE)[2]
outfile2 <- commandArgs(trailingOnly=TRUE)[3]
outfile3 <- commandArgs(trailingOnly=TRUE)[4]
stage <- commandArgs(trailingOnly=TRUE)[5]

# Loading
count <- read.table(infile, header=TRUE)

# Preprocessing
row_names <- count[,1]
count <- as.matrix(count[, 7:33])
rownames(count) <- row_names

# Setting
group <- data.frame(con = factor(c(rep("control", 3), rep("half", 3))))

# Index of corresponding samples
idx <- .sample_position[[stage]]

# DESeq2
dds <- DESeqDataSetFromMatrix(countData = count[, idx],
    colData = group, design = ~ con)
dds <- estimateSizeFactors(dds)
dds <- estimateDispersions(dds)
dds <- nbinomWaldTest(dds)
res <- results(dds)
all <- as.data.frame(head(res, nrow(count)))
deg <- all[which(all$padj < 0.1), ]

# Save
save(res, file=outfile1)
write.table(all, outfile2)
write.table(deg, outfile3)
