#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 04:00:00
#SBATCH -J BLAST
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=BLAST.%j.out
#SBATCH --error=BLAST.%j.err

module load bioinfo-tools
module load blast/2.9.0+

blastn -query matching_sequences_30.fasta -db nr -out results.txt -remote


