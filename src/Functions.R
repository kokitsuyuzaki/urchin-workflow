library("tximport")
library("edgeR")
library("DESeq2")
library("xlsx")
library("ggplot2")
library("VennDiagram")
library("tagcloud")

# Sample Name Vector
full_sample_name <- c(
    "11h_cont_1", "11h_cont_2", "11h_cont_3",
    "11h_half_1", "11h_half_2", "11h_half_3",
    "14h_cont_1", "14h_cont_2", "14h_cont_3",
    "14h_half_1", "14h_half_2", "14h_half_3",
    "18h_cont_1", "18h_cont_2", "18h_cont_3",
    "18h_half_1", "18h_half_2", "18h_half_3",
    "24h_cont_1", "24h_cont_2", "24h_cont_3",
    "24h_half_1", "24h_half_2", "24h_half_3",
    "2cell_cont_1", "2cell_cont_2", "2cell_cont_3")

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

sorted_sample_name_wo_2cells <- c(
    "11h_cont", "14h_cont", "18h_cont", "24h_cont",
    "11h_half", "14h_half", "18h_half", "24h_half")

sorted_sample_name_cont_wo_2cells <- c("11h_cont", "14h_cont", "18h_cont", "24h_cont")

sorted_sample_name_half_wo_2cells <- c("11h_half", "14h_half", "18h_half", "24h_half")

sorted_sample_name_cont <- c("2cell_cont", sorted_sample_name_cont_wo_2cells)

sorted_sample_name_half <- c("2cell_cont", sorted_sample_name_half_wo_2cells)

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

# w_barycenter
.barycenter <- function(coordinates, sorted_sample_name, n_conditions){
    replicates <- rep(seq(n_conditions), each=3)
    out <- t(sapply(seq(n_conditions), function(x){
        colMeans(coordinates[which(replicates == x), ])
    }))
    rownames(out) <- sorted_sample_name
    out
}
