source("src/Functions.R")

# Parameter
count <- commandArgs(trailingOnly=TRUE)[1]
db <- commandArgs(trailingOnly=TRUE)[2]
type <- commandArgs(trailingOnly=TRUE)[3]
outfile <- commandArgs(trailingOnly=TRUE)[4]

# Loading
infile1 <- paste0("output/pca/", count, "_", db, "_", type, "_coordinates.csv")
infile2 <- paste0("output/pca/", count, "_", db, "_", type, "_variance.csv")
coordinates <- read.table(infile1)
explained <- unlist(read.table(infile2))

# Label
xlab <- paste0("PC1 (", round(explained[1], 4)*100, " %)")
ylab <- paste0("PC2 (", round(explained[2], 4)*100, " %)")

# Plot
png(file=outfile, width=700, height=700)
par(ps=22)
plot(coordinates[,1:2], col=colvec, pch=pchvec,
    cex=3, xlab=xlab, ylab=ylab)
if((count == "SalmonTPMs") && (db == "hpbase")){
    legend("topright",
        fill = colvec[sorted_sample_name],
        legend = sorted_sample_name)
}else{
    legend("bottomright",
        fill = colvec[sorted_sample_name],
        legend = sorted_sample_name)
}
dev.off()
