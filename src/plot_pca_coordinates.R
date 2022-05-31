source("src/Functions.R")

# Parameter
count <- commandArgs(trailingOnly=TRUE)[1]
db <- commandArgs(trailingOnly=TRUE)[2]
type <- commandArgs(trailingOnly=TRUE)[3]
outfile1 <- commandArgs(trailingOnly=TRUE)[4]
outfile2 <- commandArgs(trailingOnly=TRUE)[5]

# Loading
infile1 <- paste0("output/pca/", count, "_", db, "_", type, "_coordinates.csv")
infile2 <- paste0("output/pca/", count, "_", db, "_", type, "_coordinates_wo_2cells.csv")
coordinates1 <- read.table(infile1)
coordinates2 <- read.table(infile2)

# Plot
png(file=outfile1, width=750, height=700)
pairs(coordinates1[,1:4], col=colvec,
    pch=pchvec, cex=3, oma=c(3,3,3,15))
par(xpd = TRUE)
legend("bottomright",
    fill = colvec[sorted_sample_name],
    legend = sorted_sample_name)
dev.off()

# Plot
png(file=outfile2, width=750, height=700)
pairs(coordinates2[,1:4], col=colvec,
    pch=pchvec, cex=3, oma=c(3,3,3,15))
par(xpd = TRUE)
legend("bottomright",
    fill = colvec[sorted_sample_name_wo_2cells],
    legend = sorted_sample_name_wo_2cells)
dev.off()
