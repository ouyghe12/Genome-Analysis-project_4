#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 20:00:00
#SBATCH -J annotation_emapper
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=annotation_emapper.%j.out
#SBATCH --error=annotation_emapper.%j.err

module load bioinfo-tools
module load eggNOG-mapper/2.1.9

emapper.py -i ./output_proteins.fasta --output ./output_real_gene_name -m diamond --cpu 4
