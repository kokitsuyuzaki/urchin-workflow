source("src/Functions.R")

# Parameter
count <- commandArgs(trailingOnly=TRUE)[1]
db <- commandArgs(trailingOnly=TRUE)[2]
type <- commandArgs(trailingOnly=TRUE)[3]
outfile1 <- commandArgs(trailingOnly=TRUE)[4]
outfile2 <- commandArgs(trailingOnly=TRUE)[5]

# Loading
infile1 <- paste0("output/pca/", count, "_", db, "_", type, "_variance.csv")
infile2 <- paste0("output/pca/", count, "_", db, "_", type, "_variance_wo_2cells.csv")
explained1 <- unlist(read.table(infile1))
explained2 <- unlist(read.table(infile2))

# Plot
png(file=outfile1, width=800, height=750)
par(ps=24)
plot(explained1, type="b",
    xlab="Dimension", ylab="Explained variance",
    pch=16, cex=2)
dev.off()

# Plot
png(file=outfile2, width=800, height=750)
par(ps=24)
plot(explained2, type="b",
    xlab="Dimension", ylab="Explained variance",
    pch=16, cex=2)
dev.off()
