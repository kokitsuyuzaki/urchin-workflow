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
annotation <- read.delim("data/hpbase/HpulGenome_v1_annot.tsv",
    header=TRUE)

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
out_11h_pos <- out_11h[which(out_11h$logFC > 0), ]
out_11h_neg <- out_11h[which(out_11h$logFC < 0), ]
out_14h_pos <- out_14h[which(out_14h$logFC > 0), ]
out_14h_neg <- out_14h[which(out_14h$logFC < 0), ]
out_18h_pos <- out_18h[which(out_18h$logFC > 0), ]
out_18h_neg <- out_18h[which(out_18h$logFC < 0), ]
out_24h_pos <- out_24h[which(out_24h$logFC > 0), ]
out_24h_neg <- out_24h[which(out_24h$logFC < 0), ]

# Save
write.xlsx(out_11h_pos, file=outfile, sheetName="11h_pos",
    row.names=FALSE)
write.xlsx(out_11h_neg, file=outfile, sheetName="11h_neg",
    row.names=FALSE, append=TRUE)
write.xlsx(out_14h_pos, file=outfile, sheetName="14h_pos",
    row.names=FALSE, append=TRUE)
write.xlsx(out_14h_neg, file=outfile, sheetName="14h_neg",
    row.names=FALSE, append=TRUE)
write.xlsx(out_18h_pos, file=outfile, sheetName="18h_pos",
    row.names=FALSE, append=TRUE)
write.xlsx(out_18h_neg, file=outfile, sheetName="18h_neg",
    row.names=FALSE, append=TRUE)
write.xlsx(out_24h_pos, file=outfile, sheetName="24h_pos",
    row.names=FALSE, append=TRUE)
write.xlsx(out_24h_neg, file=outfile, sheetName="24h_neg",
    row.names=FALSE, append=TRUE)
