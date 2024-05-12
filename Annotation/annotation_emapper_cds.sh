#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 10
#SBATCH -t 20:00:00
#SBATCH -J annotation_emapper_cds
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=annotation_emapper_cds.%j.out
#SBATCH --error=annotation_emapper_cds.%j.err

module load bioinfo-tools
module load eggNOG-mapper/2.1.9

emapper.py -m mmseqs --itype CDS --translate -i ./cds_fixed.fasta -o output_prefix --decorate_gff ./augustus_hints_cleaned_fixed.gff --decorate_gff_ID_field GeneID --cpu 10
