#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 20:00:00
#SBATCH -J RNA_Pilon_STAR
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=RNA_Pilon_STAR.%j.out
#SBATCH --error=RNA_Pilon_STAR.%j.err

module load bioinfo-tools
module load star/2.7.11a

genomeDir=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/Align/RNA_Pilon/index/
runThreadN=4
outDir=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/RNA_seq/untrimm

STAR --runThreadN $runThreadN \
     --runMode genomeGenerate \
     --genomeDir $genomeDir \
     --genomeFastaFiles /home/ouyghe/genome_analysis/Genome-Analysis-project_4/DNA_assembly/pilon/pilon.fasta.masked \
     --genomeSAindexNbases 11

read1=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/RNA_seq/untrimm/SRR6040095_scaffold_06_paired.1.fastq.gz
read2=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/RNA_seq/untrimm/SRR6040095_scaffold_06_paired.2.fastq.gz
sample="SRR6040095"    
STAR --genomeDir $genomeDir \
     --readFilesIn $read1 \
     --runThreadN $runThreadN \
     --outFileNamePrefix $outDir/${sample}_1_ \
     --outSAMtype BAM SortedByCoordinate \
     --readFilesCommand zcat

STAR --genomeDir $genomeDir \
     --readFilesIn $read2 \
     --runThreadN $runThreadN \
     --outFileNamePrefix $outDir/${sample}_2_ \
     --outSAMtype BAM SortedByCoordinate \
     --readFilesCommand zcat