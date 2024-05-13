library(clusterProfiler)
library(enrichplot)
library(ggplot2)
library(stringr)

egg <- read.table("go_files.txt",sep="\t",header=T, stringsAsFactors = FALSE)
gene_ids <- egg$query
eggnog_lines_with_go <- egg$GOs!= ""
eggnog_annotations_go <- str_split(egg[eggnog_lines_with_go, 'GOs'], ",")
gene_to_go <- data.frame(
  gene = rep(gene_ids[eggnog_lines_with_go], times = sapply(eggnog_annotations_go, length)),
  term = unlist(eggnog_annotations_go)
)
term2gene <- gene_to_go[, c("term", "gene")]
names(term2gene) <- c("GO", "GENE") 
go2term <- go2term(term2gene$GO)
go2ont <- go2ont(term2gene$GO)
gene1 <- read.table("up_genes.txt", header = FALSE, stringsAsFactors = FALSE)
if (is.data.frame(gene1)) {   
  gene1 <- gene1$V1
}
df <- enricher(
  gene = gene1,
  TERM2GENE = term2gene,
  TERM2NAME = go2term,
  pvalueCutoff = 1,
  qvalueCutoff = 1
)
p1 <- dotplot(df, showCategory = 15 ,title = "barplot for enricher")
p1
p2 <- p1 + scale_color_continuous(low = "purple", high = "green") + scale_size(range = c(5, 15)) + scale_y_discrete(labels = function(y) str_wrap(y, width = 20))
p2     
p3 <- cnetplot(df, node_label = "all", showCategory = 6)
p3
p4 <- cnetplot(df, circular = TRUE, colorEdge = TRUE, node_label = "category", showCategory = 6) 
p4 
gene2 <- read.table("down_genes.txt", header = FALSE, stringsAsFactors = FALSE)
if (is.data.frame(gene2)) {   
  gene2 <- gene2$V1 
}
df1 <- enricher(
  gene = gene2,
  TERM2GENE = term2gene,
  TERM2NAME = go2term,
  pvalueCutoff = 1,
  qvalueCutoff = 1
)
p5 <- dotplot(df1, showCategory = 15 ,title = "barplot for enricher")
p5
p6 <- p5 + scale_color_continuous(low = "purple", high = "green") + scale_size(range = c(5, 15)) + scale_y_discrete(labels = function(y) str_wrap(y, width = 20))
p6     
p7 <- cnetplot(df1, node_label = "all", showCategory = 6)
p7
p8 <- cnetplot(df1, circular = TRUE, colorEdge = TRUE, node_label = "category", showCategory = 6) 
p8
