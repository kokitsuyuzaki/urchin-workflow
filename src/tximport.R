source("src/Functions.R")

# Parameter
db <- commandArgs(trailingOnly=TRUE)[1]
type <- commandArgs(trailingOnly=TRUE)[2]
outfile1 <- commandArgs(trailingOnly=TRUE)[3]
outfile2 <- commandArgs(trailingOnly=TRUE)[4]
sample_id <- unique(read.csv("data/sample_sheet.csv", header=FALSE)[,1])

# Salmon's files
file_salmon <- paste("data", db, type, sample_id, "salmon", "quant.sf", sep="/")

# Loading
txi_salmon_transcript <- tximport(file_salmon, type="salmon", txOut=TRUE)

# Save (Count)
out1 <- txi_salmon_transcript$counts
colnames(out1) <- sample_id
write.table(txi_salmon_transcript$counts, file=outfile1)

# Save (TPM)
out2 <- txi_salmon_transcript$abundance
colnames(out2) <- sample_id
write.table(txi_salmon_transcript$abundance, file=outfile2)
