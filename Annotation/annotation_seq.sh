#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 20:00:00
#SBATCH -J annotation_seq
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=annotation_seq.%j.out
#SBATCH --error=annotation_seq.%j.err

module load bioinfo-tools 
module load BEDTools/2.31.1
module load gffread/0.12.7

genomeDir=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/DNA_assembly/pilon/pilon.fasta.masked
gftDir=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/Annotation/braker/Durio_zibethinus/augustus.hints.gtf

bedtools getfasta -fi $genomeDir -bed ./augustus_hints_cleaned_fixed.gff -fo genes_sequences.fasta -name
gffread -y output_proteins.fa -g $genomeDir ./augustus_hints_cleaned_fixed.gff 
gffread -w output_transcript_sequences.fasta -g $genomeDir ./augustus_hints_cleaned_fixed.gff
gffread -x ./output_cds.fasta -g $genomeDir $gftDir
