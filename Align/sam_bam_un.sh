#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 02:00:00
#SBATCH -J unalign_sam_bam
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=sam_bam_un.%j.out
#SBATCH --error=sam_bam_un.%j.err

module load bioinfo-tools
module load samtools

samtools view -Sb unaligned_reads.sam | samtools sort -o sorted_output_un.bam
samtools index sorted_output_un.bam
