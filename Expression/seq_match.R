library(Biostrings)

gene_names <- readLines("top30_genes.txt")
fasta_sequences <- readDNAStringSet("output_transcript_sequences.fasta", format = "fasta")
names_fasta_sequences <- sapply(strsplit(names(fasta_sequences), "\\."), `[`, 1)

gene_names <- gene_names[gene_names != "x"]

matching_indices <- which(names_fasta_sequences %in% gene_names)

matching_sequences <- fasta_sequences[matching_indices]

writeXStringSet(matching_sequences, "matching_sequences_30.fasta")
