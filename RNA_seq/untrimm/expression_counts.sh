#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 20:00:00
#SBATCH -J RNA_Pilon_expression
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=RNA_Pilon_expression.%j.out
#SBATCH --error=RNA_Pilon_expression.%j.err

module load bioinfo-tools
module load htseq/2.0.2
module load samtools

gffFile=/domus/h1/ouyghe/genome_analysis/Genome-Analysis-project_4/Expression/augustus_hints_cleaned_fixed.gff

bamFiles_1=SRR6040095_1_Aligned.sortedByCoord.out.bam
bamFiles_2=SRR6040095_2_Aligned.sortedByCoord.out.bam

samtools index $bamFiles_1
filename_1=$(basename -- $bamFiles_1)
outputFilename_1=${filename_1%.bam}_counts.txt
htseq-count -f bam -r pos -s no -t gene -i gene_id $bamFiles_1 $gffFile > ./${outputFilename_1}

samtools index $bamFiles_2
filename_2=$(basename -- $bamFiles_2)
outputFilename_2=${filename_2%.bam}_counts.txt
htseq-count -f bam -r pos -s no -t gene -i gene_id $bamFiles_2 $gffFile > ./${outputFilename_2}
