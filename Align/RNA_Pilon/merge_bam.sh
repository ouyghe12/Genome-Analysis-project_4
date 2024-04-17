#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 02:00:00
#SBATCH -J merge_bam
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=mergebam.%j.out
#SBATCH --error=merge_bam.%j.err

module load bioinfo-tools
module load samtools

samtools merge merged.bam ./SRR6040092_Aligned.sortedByCoord.out.bam ./SRR6040093_Aligned.sortedByCoord.out.bam \
                          ./SRR6040094_Aligned.sortedByCoord.out.bam ./SRR6040096_Aligned.sortedByCoord.out.bam \
                          ./SRR6040097_Aligned.sortedByCoord.out.bam ./SRR6156066_Aligned.sortedByCoord.out.bam \
                          ./SRR6156067_Aligned.sortedByCoord.out.bam ./SRR6156069_Aligned.sortedByCoord.out.bam
