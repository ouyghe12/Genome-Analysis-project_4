#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 10
#SBATCH -t 5:00:00
#SBATCH -J vcf
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=RNA_assembly.%j.out
#SBATCH --error=RNA_assembly.%j.err

module load bioinfo-tools 
module load bowtie2
module load samtools
module load bcftools

cd $SNIC_TMP
mkdir -p VCF
cd VCF
export SRCDIR=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/Align/VCF
ln -s /home/ouyghe/genome_analysis/Genome-Analysis-project_4/DNA_assembly/flye/assembly.fasta .
ln -s /proj/uppmax2024-2-7/Genome_Analysis/4_Tean_Teh_2017/transcriptome/trimmed/*_06.*.fastq.gz .
ln -s /home/ouyghe/genome_analysis/Genome-Analysis-project_4/RNA_seq/untrimm/SRR6040095_scaffold_06_paired.1.fastq.gz .
ln -s /home/ouyghe/genome_analysis/Genome-Analysis-project_4/RNA_seq/untrimm/SRR6040095_scaffold_06_paired.2.fastq.gz .

bowtie2-build assembly.fasta genome

i=1
for sample in SRR6040092 SRR6040093 SRR6040094 SRR6040096 SRR6040097 SRR6156066 SRR6156067 SRR6156069 SRR6040095
do
    process_sample() {
    bowtie2 -x genome -U "$sample"_*.fastq.gz | \
    samtools sort -O bam -o "$sample".bam - && \
    samtools index "$sample".bam && \
    bcftools mpileup -f assembly.fasta "$sample".bam | \
    bcftools call -mv -Ob -o "$sample".bcf && \
    bcftools view "$sample".bcf -o "$sample".vcf && \
    cp "$sample".vcf $SRCDIR/ && \
    echo "Completed: $sample"
  } 

  process_sample "$sample" &

  if (( $(($i % 5)) == 0 )); then
    wait
  fi

done
wait 

echo "All processes completed."