source("src/Functions.R")

# Parameter
count <- commandArgs(trailingOnly=TRUE)[1]
db <- commandArgs(trailingOnly=TRUE)[2]
type <- commandArgs(trailingOnly=TRUE)[3]
outfile <- commandArgs(trailingOnly=TRUE)[4]

# Loading
infile <- paste0("output/pca/", count, "_", db, "_", type, "_coordinates.csv")
coordinates <- read.table(infile)

# Plot
png(file=outfile, width=750, height=700)
pairs(coordinates[,1:4], col=colvec,
    pch=pchvec, cex=3, oma=c(3,3,3,15))
par(xpd = TRUE)
legend("bottomright",
    fill = colvec[sorted_sample_name],
    legend = sorted_sample_name)
dev.off()
