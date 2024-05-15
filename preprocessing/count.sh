#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J counts
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=counts.%j.out
#SBATCH --error=counts.%j.err


input_1="../illumina/SRR6058604_scaffold_06.1P.fastq.gz"
input_2="../illumina/SRR6058604_scaffold_06.2P.fastq.gz"
trimmed_paired_1="./SRR6058604_scaffold_06_paired.1P.fastq.gz"
trimmed_paired_2="./SRR6058604_scaffold_06_paired.2P.fastq.gz"
trimmed_unpaired_1="./SRR6058604_scaffold_06_unpaired.1P.fastq.gz"
trimmed_unpaired_2="./SRR6058604_scaffold_06_unpaired.2P.fastq.gz"

original_read_count_1=$(zcat $input_1 | wc -l)
original_read_count_1=$((original_read_count_1 / 4))

original_read_count_2=$(zcat $input_2 | wc -l)
original_read_count_2=$((original_read_count_2 / 4))

trimmed_read_count_paired_1=$(zcat $trimmed_paired_1 | wc -l)
trimmed_read_count_paired_1=$((trimmed_read_count_paired_1 / 4))

trimmed_read_count_paired_2=$(zcat $trimmed_paired_2 | wc -l)
trimmed_read_count_paired_2=$((trimmed_read_count_paired_2 / 4))


trimmed_read_count_unpaired_1=$(zcat $trimmed_unpaired_1 | wc -l)
trimmed_read_count_unpaired_1=$((trimmed_read_count_unpaired_1 / 4))

trimmed_read_count_unpaired_2=$(zcat $trimmed_unpaired_2 | wc -l)
trimmed_read_count_unpaired_2=$((trimmed_read_count_unpaired_2 / 4))


discarded_reads_1=$((original_read_count_1 - trimmed_read_count_paired_1 - trimmed_read_count_unpaired_1))
discarded_reads_2=$((original_read_count_2 - trimmed_read_count_paired_2 - trimmed_read_count_unpaired_2))


echo "Original reads (pair 1): $original_read_count_1" > read_counts.txt
echo "Original reads (pair 2): $original_read_count_2" >> read_counts.txt
echo "Trimmed paired reads (pair 1): $trimmed_read_count_paired_1" >> read_counts.txt
echo "Trimmed paired reads (pair 2): $trimmed_read_count_paired_2" >> read_counts.txt
echo "Trimmed unpaired reads (pair 1): $trimmed_read_count_unpaired_1" >> read_counts.txt
echo "Trimmed unpaired reads (pair 2): $trimmed_read_count_unpaired_2" >> read_counts.txt
echo "Discarded reads (pair 1): $discarded_reads_1" >> read_counts.txt
echo "Discarded reads (pair 2): $discarded_reads_2" >> read_counts.txt