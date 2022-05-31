source("src/Functions.R")

# Parameter
counts <- commandArgs(trailingOnly=TRUE)[1]
db <- commandArgs(trailingOnly=TRUE)[2]
type <- commandArgs(trailingOnly=TRUE)[3]
outfile <- commandArgs(trailingOnly=TRUE)[4]
infile <- paste0("output/", counts, "_", db, "_", type, ".txt")

# Loading
if(counts == "FeatureCounts"){
    mat <- as.matrix(read.table(infile, header=TRUE)[, 7:33])
}else{
    mat <- as.matrix(read.table(infile))
}
colnames(mat) <- full_sample_name

# Correlationship
cor_mat <- cor(mat)

# Plot
png(file=outfile, width=1000, height=1000)
par(ps=25)
heatmap(cor_mat, margins=c(10,10))
dev.off()
