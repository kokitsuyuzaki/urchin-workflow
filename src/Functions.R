library("tximport")
library("edgeR")
library("DESeq2")
library("xlsx")
library("ggplot2")

# Sample Name Vector
sample_name <- c(
    "11h_cont", "11h_half",
    "14h_cont", "14h_half",
    "18h_cont", "18h_half",
    "24h_cont", "24h_half",
    "2cell_cont")

sorted_sample_name <- c(
    "11h_cont", "14h_cont", "18h_cont", "24h_cont",
    "11h_half", "14h_half", "18h_half", "24h_half",
    "2cell_cont")

# Color Vector
color_scheme <- c(
    "#FF40FF", "#CCFF00",
    "#9D00FF", "#05FF01",
    "#7E00FF", "#02FFC6",
    "#4800FF", "#00F7FF",
    rgb(0.3,0.3,0.3))

colvec <- rep(color_scheme, each=3)
names(colvec) <- rep(sample_name, each=3)

# Replicate Vecot
pchvec <- rep(c(16,17,15), 9)

# DEG design matrix
.sample_position <- list(
    "11h" = 1:6,
    "14h" = 7:12,
    "18h" = 13:18,
    "24h" = 19:24)
