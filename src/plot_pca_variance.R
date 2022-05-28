source("src/Functions.R")

# Parameter
count <- commandArgs(trailingOnly=TRUE)[1]
db <- commandArgs(trailingOnly=TRUE)[2]
type <- commandArgs(trailingOnly=TRUE)[3]
outfile <- commandArgs(trailingOnly=TRUE)[4]

# Loading
infile <- paste0("output/pca/", count, "_", db, "_", type, "_variance.csv")
explained <- unlist(read.table(infile))

# Plot
png(file=outfile, width=800, height=750)
par(ps=24)
plot(explained, type="b",
    xlab="Dimension", ylab="Explained variance",
    pch=16, cex=2)
dev.off()
