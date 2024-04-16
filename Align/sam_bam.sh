#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 02:00:00
#SBATCH -J align_sam_bam
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=sam_bam.%j.out
#SBATCH --error=sam_bam.%j.err

module load bioinfo-tools
module load samtools

samtools view -Sb aligned_reads.sam | samtools sort -o sorted_output.bam
samtools index sorted_output.bam
