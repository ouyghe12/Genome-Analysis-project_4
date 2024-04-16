#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 05:00:00
#SBATCH -J assemble_pilon
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=assemble_pilon.%j.out
#SBATCH --error=assemble_pilon.%j.err

module load bioinfo-tools
module load Pilon/1.24

PREPROCESSING_DIR="/home/ouyghe/genome_analysis/Genome-Analysis-project_4/"
java -jar /sw/bioinfo/Pilon/1.24/rackham/pilon.jar --genome $PREPROCESSING_DIR/DNA_assembly/assembly.fasta \
	  --frags $PREPROCESSING_DIR/Align/sorted_output.bam \
	  --unpaired $PREPROCESSING_DIR/Align/sorted_output_un.bam
