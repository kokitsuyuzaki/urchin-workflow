source("src/Functions.R")

# Parameter
db <- commandArgs(trailingOnly=TRUE)[1]
type <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]
sample_id <- unique(read.csv("data/sample_sheet.csv", header=FALSE)[,1])

# Transcript ID <-> Gene ID
if(db == "hpbase"){
    # HpBase
    annotation <- read.delim("data/hpbase/HpulGenome_v1_annot.tsv",
        header=TRUE)
    tx2gene <- data.frame(
        TXNAME=annotation[, "HPU_transcriptome_besthit"],
        GENEID=annotation[, "HPU_gene_id"])
    tx2gene$TXNAME <- gsub("\\|.*", "", tx2gene$TXNAME)
}else{
    # EchinoBase
    annotation <- read.delim("data/echinobase/sp5_0_GCF.gff3",
        skip=5, header=FALSE)
    tx2gene <- data.frame(
        TXNAME=.extractRefSeqID(annotation[, 9]),
        GENEID=.extractGeneID(annotation[, 9]))
    tx2gene <- tx2gene[which(!.is.empty(tx2gene[,1])), ]
    tx2gene <- tx2gene[which(!.is.empty(tx2gene[,2])), ]
    tx2gene <- unique(tx2gene)
}

# Salmon's files
file_salmon <- paste("data", db, type, sample_id, "salmon", "quant.sf", sep="/")

# Loading
txi_salmon_transcript <- tximport(file_salmon, type="salmon", txOut=TRUE)

# summarizeToGene
txi_salmon_gene <- summarizeToGene(txi_salmon_transcript, tx2gene,
    countsFromAbundance="lengthScaledTPM")

# Save
save(txi_salmon_transcript, txi_salmon_gene, file=outfile)
