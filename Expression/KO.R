library(clusterProfiler)
library(pathview)
library(enrichplot) 
library(ggplot2) 
library(stringr)
data <- read.csv("ko_files.csv", header = TRUE)
genes <- read.table("upko_genes.txt", header = FALSE, stringsAsFactors = FALSE)
genes <- genes$V1
matched_ko <- data[data$query %in% genes, ]
print(matched_ko)
gene_list <- setNames(matched_ko$KEGG_ko, matched_ko$query)
kk <- enrichKEGG(gene = gene_list, organism = 'ko', keyType = "kegg")
summary(kk)
dotplot(kk) + ggtitle("KEGG Pathway Enrichment For up Genes")
barplot(kk) + ggtitle("KEGG Pathway Enrichment For up Genes")

genes1 <- read.table("downko_genes.txt", header = FALSE, stringsAsFactors = FALSE)
genes1 <- genes1$V1
matched_ko1 <- data[data$query %in% genes1, ]
print(matched_ko1)
gene_list1 <- setNames(matched_ko1$KEGG_ko, matched_ko1$query)
kk1 <- enrichKEGG(gene = gene_list1, organism = 'ko', keyType = "kegg")
summary(kk1)
dotplot(kk1) + ggtitle("KEGG Pathway Enrichment For down Genes")
barplot(kk1) + ggtitle("KEGG Pathway Enrichment For down Genes")
