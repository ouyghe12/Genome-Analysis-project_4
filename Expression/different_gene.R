library(DESeq2)
library(tidyverse)
library(pheatmap)
library(ggplot2)
library(ggrepel)

counts <- read.table("counts.txt", header = TRUE, sep = "\t", fill = TRUE, quote = "")
if (!anyDuplicated(counts[, 1])) {
  rownames(counts) <- counts[, 1]
  counts <- counts[, -1]
} else {
  cat("Warning: Duplicated row names detected in the first column.")
}


sample_names <- colnames(counts)
conditions_mk <- ifelse(grepl("LEAF", sample_names), "LEAF_MK",
                        ifelse(grepl("ROOT", sample_names), "ROOT_MK",
                               ifelse(grepl("STEM", sample_names), "STEM_MK",
                                      ifelse(grepl("ARIL2", sample_names), "ARIL2_MK",
                                             ifelse(grepl("ARIL1", sample_names), "ARIL1_MK",
                                                    ifelse(grepl("ARIL3", sample_names), "ARIL3_MK", NA))))))

conditions_m <- ifelse(grepl("ARIL1_1_M", sample_names), "ARIL1_M",
                       ifelse(grepl("ARIL2_1_M", sample_names), "ARIL2_M",
                              ifelse(grepl("ARIL3_1_M", sample_names), "ARIL3_M", NA)))
conditions <- ifelse(is.na(conditions_m), conditions_mk, conditions_m)
sample_info <- data.frame(
  sample_name = sample_names,
  condition = conditions
)
dds <- DESeqDataSetFromMatrix(countData = counts,
                              colData = sample_info,
                              design = ~ condition)
dds <- DESeq(dds)
comparisons <- list(
  "LEAF_vs_ROOT" = c("condition", "LEAF_MK", "ROOT_MK"),
  "LEAF_vs_STEM" = c("condition", "LEAF_MK", "STEM_MK"),
  "STEM_vs_ARIL2" = c("condition", "STEM_MK", "ARIL2_MK"),
  "STEM_vs_ARIL3" = c("condition", "STEM_MK", "ARIL3_MK"),
  "ARIL2_vs_ARIL3" = c("condition", "ARIL2_MK", "ARIL3_MK"),
  "ARIL2_vs_ROOT" = c("condition", "ARIL2_MK", "ROOT_MK"),
  "ARIL2_vs_LEAF" = c("condition", "ARIL2_MK", "LEAF_MK"),
  "ROOT_vs_ARIL3" = c("condition", "ROOT_MK", "ARIL3_MK"),
  "LEAF_vs_ARIL3" = c("condition", "LEAF_MK", "ARIL3_MK"),
  "STEM_vs_ROOT" = c("condition", "STEM_MK", "ROOT_MK"),
  "M_ARIL1_vs_ARIL2" = c("condition", "ARIL1_M", "ARIL2_M"),
  "M_ARIL1_vs_ARIL3" = c("condition", "ARIL1_M", "ARIL3_M"),
  "M_ARIL2_vs_ARIL3" = c("condition", "ARIL2_M", "ARIL3_M"),
  "MK_vs_M_ARIL2" = c("condition", "ARIL2_MK", "ARIL2_M"),
  "MK_vs_M_ARIL3" = c("condition", "ARIL3_MK", "ARIL3_M"),
  "LEAF_vs_ARIL1" = c("condition", "LEAF_MK", "ARIL1_MK"),
  "ROOT_vs_ARIL1" = c("condition", "ROOT_MK", "ARIL1_MK"),
  "STEM_vs_ARIL1" = c("condition", "STEM_MK", "ARIL1_MK"),
  "ARIL2_vs_ARIL1" = c("condition", "ARIL2_MK", "ARIL1_MK"),
  "ARIL3_vs_ARIL1" = c("condition", "ARIL3_MK", "ARIL1_MK"),
  "MK_vs_M_ARIL1" = c("condition", "ARIL1_MK", "ARIL1_M")
)
results_list <- list()
for (comp_name in names(comparisons)) {
  res <- results(dds, contrast=comparisons[[comp_name]])
  results_list[[comp_name]] <- res
}

significant_genes <- sapply(results_list, function(res) {
  res <- res[which(res$padj < 0.05 & !is.na(res$padj)),]
  res$gene <- rownames(res)
  res
})
significant_genes <- do.call(rbind, significant_genes)
unique_genes <- unique(significant_genes$gene)
write.table(unique_genes, file="unique_genes.txt", quote=FALSE, row.names=FALSE)
unique_significant_genes <- significant_genes[!duplicated(significant_genes$gene), ]
top30_genes <- unique_significant_genes[order(unique_significant_genes$padj),][1:30,]
write.table(top30_genes$gene, file="top30_genes.txt", quote=FALSE, row.names=FALSE)
counts_filtered <- counts[top30_genes$gene, , drop=FALSE]
log_counts <- log2(counts_filtered + 1)
dds_norm <- assay(rlog(dds, blind=FALSE))
pheatmap(dds_norm[top30_genes$gene, ], cluster_rows=TRUE, cluster_cols=TRUE, show_rownames=TRUE, show_colnames=TRUE)

upregulated_genes <- significant_genes[significant_genes$log2FoldChange > 0, ]
upregulated_genes_list <- list()
upregulated_genes_list[["up_comp"]] <- upregulated_genes

downregulated_genes <- significant_genes[significant_genes$log2FoldChange < 0, ]
downregulated_genes_list <- list()
downregulated_genes_list[["down_comp"]] <- downregulated_genes

write.table(upregulated_genes, 
            file="upregulated_genes.csv", 
            sep=",",  
            quote=FALSE, 
            row.names=FALSE, 
            col.names=TRUE) 

write.table(downregulated_genes, 
            file="downregulated_genes.csv", 
            sep=",", 
            quote=FALSE, 
            row.names=FALSE, 
            col.names=TRUE)

rld <- rlog(dds, blind=FALSE)
pca_data <- prcomp(t(assay(rld)))
pca_df <- data.frame(PC1 = pca_data$x[, 1], PC2 = pca_data$x[, 2], condition = sample_info$condition)
ggplot(pca_df, aes(x = PC1, y = PC2, color = condition, label = rownames(pca_df))) +
  geom_point(alpha=0.8, size=3) +
  geom_text_repel() +
  theme_minimal() +
  ggtitle("PCA of Sample Conditions") +
  xlab("PC1") + ylab("PC2")

filtered_results_list <- list()
for (comp_name in names(results_list)) {
  res <- results_list[[comp_name]]
  significant_res <- res[!is.na(res$padj) & res$padj < 0.05, ]
  filtered_results_list[[comp_name]] <- significant_res
}
for (comp_name in names(filtered_results_list)) {
  write.csv(filtered_results_list[[comp_name]], paste0(comp_name, "_filtered.csv"))
}

upregulated_genes_list <- list()
downregulated_genes_list <- list()
result_counts <- data.frame(Comparison = character(), Upregulated = integer(), Downregulated = integer(), stringsAsFactors = FALSE)
for (comp_name in names(filtered_results_list)) {
  upregulated_genes <- filtered_results_list[[comp_name]][filtered_results_list[[comp_name]]$log2FoldChange > 0, ]
  upregulated_genes_list[[comp_name]] <- upregulated_genes
  downregulated_genes <- filtered_results_list[[comp_name]][filtered_results_list[[comp_name]]$log2FoldChange < 0, ]
  downregulated_genes_list[[comp_name]] <- downregulated_genes
  up_count <- nrow(upregulated_genes)
  down_count <- nrow(downregulated_genes)
  result_counts <- rbind(result_counts, data.frame(Comparison = comp_name, Upregulated = up_count, Downregulated = down_count, stringsAsFactors = FALSE))
}
write.csv(result_counts, "gene_regulation_counts.csv", row.names = FALSE)

for (comp_name in names(comparisons)) {
  res <- results(dds, contrast=comparisons[[comp_name]])
  results_list[[comp_name]] <- res
  
  png(paste0(comp_name, "_MA_plot.png"))
  plotMA(res, main=paste("MA Plot:", comp_name), ylim=c(-5,5))
  dev.off()
  
  res$padj <- p.adjust(res$pvalue, method = "BH")
  

  p <- ggplot(res, aes(x = log2FoldChange, y = -log10(pvalue), color = padj < 0.05)) +
    geom_point(alpha = 0.5) +
    scale_color_manual(values = c("grey", "red"), labels = c("Not significant", "Significant")) +
    labs(title = paste("Volcano Plot:", comp_name), x = "Log2 Fold Change", y = "-Log10 P-value") +
    theme_minimal()
  
  ggsave(paste0(comp_name, "_volcano_plot.png"), plot = p)
}


