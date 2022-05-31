source("src/Functions.R")

# Parameter
count <- commandArgs(trailingOnly=TRUE)[1]
db <- commandArgs(trailingOnly=TRUE)[2]
type <- commandArgs(trailingOnly=TRUE)[3]
outfile1 <- commandArgs(trailingOnly=TRUE)[4]
outfile2 <- commandArgs(trailingOnly=TRUE)[5]

# Loading
infile1 <- paste0("output/pca/", count, "_", db, "_", type, "_coordinates.csv")
infile2 <- paste0("output/pca/", count, "_", db, "_", type, "_variance.csv")
infile3 <- paste0("output/pca/", count, "_", db, "_", type, "_coordinates_wo_2cells.csv")
infile4 <- paste0("output/pca/", count, "_", db, "_", type, "_variance_wo_2cells.csv")

coordinates1 <- read.table(infile1)
explained1 <- unlist(read.table(infile2))
coordinates2 <- read.table(infile3)
explained2 <- unlist(read.table(infile4))

# Gene Expression
infile5 <- paste0("data/", db, "/", type, "/mapping_rate.txt")
mat <- read.table(infile5)
mapping_rates <- mat[,2]

# Setting
xlab1 <- paste0("PC1 (", round(explained1[1], 4)*100, " %)")
ylab1 <- paste0("PC2 (", round(explained1[2], 4)*100, " %)")
xlab2 <- paste0("PC1 (", round(explained2[1], 4)*100, " %)")
ylab2 <- paste0("PC2 (", round(explained2[2], 4)*100, " %)")
colvec <- smoothPalette(-mapping_rates, pal="RdBu")

# Plot
png(file=outfile1, width=700, height=700)
par(ps=22)
plot(coordinates1[,1:2], col=colvec, pch=pchvec,
    cex=3, xlab=xlab1, ylab=ylab1)
dev.off()

# Plot
png(file=outfile2, width=700, height=700)
par(ps=22)
plot(coordinates2[,1:2], col=colvec, pch=pchvec,
    cex=3, xlab=xlab2, ylab=ylab2)
dev.off()
