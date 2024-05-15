#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J QC
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=QC.%j.out
#SBATCH --error=QC.%j.err

module load bioinfo-tools
module load FastQC/0.11.9

fastqc -o ../PacBio/fastqc_results ../PacBio/SRR6037732_scaffold_06.fq.gz

fastqc -o ../illumina/fastqc_results ../illumina/SRR6058604_scaffold_06.1P.fastq.gz ../illumina/SRR6058604_scaffold_06.2P.fastq.gz

fastqc -o ./fastqc_results ./SRR6058604_scaffold_06_paired.1P.fastq.gz ./SRR6058604_scaffold_06_paired.2P.fastq.gz
