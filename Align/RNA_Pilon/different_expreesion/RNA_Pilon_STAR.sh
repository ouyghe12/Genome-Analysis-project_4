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
outDir=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/Align/RNA_Pilon//different_expreesion/

STAR --runThreadN $runThreadN \
     --runMode genomeGenerate \
     --genomeDir $genomeDir \
     --genomeFastaFiles /home/ouyghe/genome_analysis/Genome-Analysis-project_4/DNA_assembly/pilon/pilon.fasta.masked \
     --genomeSAindexNbases 11

for sample in SRR6040092 SRR6040093 SRR6040094 SRR6040096 SRR6040097 SRR6156066 SRR6156067 SRR6156069; do
    read1=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/RNA_seq/${sample}_scaffold_06.1.fastq.gz
    STAR --genomeDir $genomeDir \
         --readFilesIn $read1 \
         --runThreadN $runThreadN \
         --outFileNamePrefix $outDir/${sample}_1_ \
         --outSAMtype BAM SortedByCoordinate \
         --readFilesCommand zcat
    read2=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/RNA_seq/${sample}_scaffold_06.2.fastq.gz
    STAR --genomeDir $genomeDir \
         --readFilesIn $read2 \
         --runThreadN $runThreadN \
         --outFileNamePrefix $outDir/${sample}_2_ \
         --outSAMtype BAM SortedByCoordinate \
         --readFilesCommand zcat
done
