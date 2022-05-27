library("tximport")
library("edgeR")
library("DESeq2")
library("xlsx")
library("Rtsne")
library("GGally")

.extractGeneID <- function(x){
    m <- regexpr("GeneID:.*?(;|,)", x)
    out <- substr(x, m, m + attr(m, "match.length") - 1)
    out <- gsub("GeneID:", "", out)
    out <- gsub(",", "", out)
    gsub(";", "", out)
}

.extractRefSeqID <- function(x){
    m <- regexpr("Name=.*?(;|,)", x)
    out <- substr(x, m, m + attr(m, "match.length") - 1)
    out <- gsub("Name=", "", out)
    out <- gsub(",", "", out)
    gsub(";", "", out)
}

.is.empty <- function(x){
    x == ""
}
