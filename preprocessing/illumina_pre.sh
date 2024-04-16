#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J illumina_pre
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=illumina_pre.%j.out
#SBATCH --error=illumina_pre.%j.err
# Load modules
module load bioinfo-tools
module load trimmomatic/0.39
# Your commands
java -jar  $TRIMMOMATIC_ROOT/trimmomatic-0.39.jar PE -phred33 \
../illumina/SRR6058604_scaffold_06.1P.fastq.gz ../illumina/SRR6058604_scaffold_06.2P.fastq.gz \
./SRR6058604_scaffold_06_paired.1P.fastq.gz ./SRR6058604_scaffold_06_unpaired.1P.fastq.gz \
./SRR6058604_scaffold_06_paired.2P.fastq.gz ./SRR6058604_scaffold_06_unpaired.2P.fastq.gz \
ILLUMINACLIP:/sw/bioinfo/trimmomatic/0.39/snowy/adapters/TruSeq3-PE.fa:2:30:10 \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 
