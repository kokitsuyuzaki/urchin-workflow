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

# Preprocessing
df <- data.frame(
    Stage=c("11h", "11h", "14h", "14h", "18h", "18h", "24h", "24h"),
    Direction=rep(c("cont < half", "cont > half"), 4),
    No_DEGs=c(
        nrow(deg_11h[which(deg_11h$logFC > 0), ]),
        nrow(deg_11h[which(deg_11h$logFC < 0), ]),
        nrow(deg_14h[which(deg_14h$logFC > 0), ]),
        nrow(deg_14h[which(deg_14h$logFC < 0), ]),
        nrow(deg_18h[which(deg_18h$logFC > 0), ]),
        nrow(deg_18h[which(deg_18h$logFC < 0), ]),
        nrow(deg_24h[which(deg_24h$logFC > 0), ]),
        nrow(deg_24h[which(deg_24h$logFC < 0), ])))

# Plot
g <- ggplot(df, aes(x=Stage, y=No_DEGs, fill=Direction))
g <- g + geom_bar(stat = "identity")
ggsave(outfile, g, dpi=120, width=7, height=7)
