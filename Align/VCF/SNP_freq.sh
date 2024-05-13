#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 5:00:00
#SBATCH -J SNP_freq_analysis
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=SNP_freq_analysis.%j.out
#SBATCH --error=SNP_freq_analysis.%j.err

module load bioinfo-tools 
module load vcftools/0.1.16
for sample in SRR6040092 SRR6040093 SRR6040094 SRR6040096 SRR6040097 SRR6156066 SRR6156067 SRR6156069 SRR6040095
do
    vcftools --vcf "$sample".vcf --freq --out "$sample"
done