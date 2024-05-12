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

rnaDir=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/Align/RNA_Pilon/different_expreesion/
gffFile=./augustus_hints_cleaned_fixed.gff

bamFiles=(
    ${rnaDir}SRR6040092_1_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6040093_1_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6040094_1_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6040096_1_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6040097_1_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6156066_1_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6156067_1_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6156069_1_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6040092_2_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6040093_2_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6040094_2_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6040096_2_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6040097_2_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6156066_2_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6156067_2_Aligned.sortedByCoord.out.bam
    ${rnaDir}SRR6156069_2_Aligned.sortedByCoord.out.bam
)

for bamFile in "${bamFiles[@]}"
do
    samtools index $bamFile
    filename=$(basename -- $bamFile)
    outputFilename=${filename%.bam}_counts.txt
    htseq-count -f bam -r pos -s no -t gene -i gene_id $bamFile $gffFile > ./${outputFilename}
    echo "Processed counts for $bamFile, output to ${rnaDir}${outputFilename}"
done
