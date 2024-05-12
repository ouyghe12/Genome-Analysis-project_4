#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 04:00:00
#SBATCH -J flye_evaluation
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=flye_evaluation.%j.out
#SBATCH --error=flye_evaluation.%j.err

module load bioinfo-tools
module load quast/5.0.2

python /sw/bioinfo/quast/5.0.2/snowy/bin/quast.py \
-o modified_quast /home/ouyghe/genome_analysis/Genome-Analysis-project_4/DNA_assembly/modified_flye/assembly.fasta \
--eukaryote --k-mer-stats --gene-finding --conserved-genes-finding
