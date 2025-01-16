source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
infile4 <- commandArgs(trailingOnly=TRUE)[4]
outfile <- commandArgs(trailingOnly=TRUE)[5]

# Loading
deg_11h <- read.table(infile1)
deg_14h <- read.table(infile2)
deg_18h <- read.table(infile3)
deg_24h <- read.table(infile4)

deg_11h <- cbind(deg_11h, id=gsub("-mRNA.*", "", rownames(deg_11h)))
deg_14h <- cbind(deg_14h, id=gsub("-mRNA.*", "", rownames(deg_14h)))
deg_18h <- cbind(deg_18h, id=gsub("-mRNA.*", "", rownames(deg_18h)))
deg_24h <- cbind(deg_24h, id=gsub("-mRNA.*", "", rownames(deg_24h)))

# HpBase Annotation
annotation <- read.xlsx("data/hpbase/HpulGenome_v1_annot.xlsx", sheet=1)

# Merge
out_11h <- merge(deg_11h, annotation, by.x="id",
    by.y="HPU_gene_id", all.x=TRUE)
out_14h <- merge(deg_14h, annotation, by.x="id",
    by.y="HPU_gene_id", all.x=TRUE)
out_18h <- merge(deg_18h, annotation, by.x="id",
    by.y="HPU_gene_id", all.x=TRUE)
out_24h <- merge(deg_24h, annotation, by.x="id",
    by.y="HPU_gene_id", all.x=TRUE)

# Direction
out_11h_pos <- out_11h[which(out_11h$log2FoldChange > 0), ]
out_11h_neg <- out_11h[which(out_11h$log2FoldChange < 0), ]
out_14h_pos <- out_14h[which(out_14h$log2FoldChange > 0), ]
out_14h_neg <- out_14h[which(out_14h$log2FoldChange < 0), ]
out_18h_pos <- out_18h[which(out_18h$log2FoldChange > 0), ]
out_18h_neg <- out_18h[which(out_18h$log2FoldChange < 0), ]
out_24h_pos <- out_24h[which(out_24h$log2FoldChange > 0), ]
out_24h_neg <- out_24h[which(out_24h$log2FoldChange < 0), ]

# Save
wb <- createWorkbook()
addWorksheet(wb, "11h_pos")
writeData(wb, "11h_pos", out_11h_pos)
addWorksheet(wb, "11h_neg")
writeData(wb, "11h_neg", out_11h_neg)

addWorksheet(wb, "14h_pos")
writeData(wb, "14h_pos", out_14h_pos)
addWorksheet(wb, "14h_neg")
writeData(wb, "14h_neg", out_14h_neg)

addWorksheet(wb, "18h_pos")
writeData(wb, "18h_pos", out_18h_pos)
addWorksheet(wb, "18h_neg")
writeData(wb, "18h_neg", out_18h_neg)

addWorksheet(wb, "24h_pos")
writeData(wb, "24h_pos", out_24h_pos)
addWorksheet(wb, "24h_neg")
writeData(wb, "24h_neg", out_24h_neg)

saveWorkbook(wb, outfile, overwrite=TRUE)
