#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 04:00:00
#SBATCH -J pacbio_illumina_unalign
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=pacbio_illumina_unalign.%j.out
#SBATCH --error=pacbio_illumina_unalign.%j.err

module load bioinfo-tools
module load bwa

PREPROCESSING_DIR="/home/ouyghe/genome_analysis/Genome-Analysis-project_4/"

bwa index $PREPROCESSING_DIR/DNA_assembly/assembly.fasta
bwa mem $PREPROCESSING_DIR/DNA_assembly/assembly.fasta \
	$PREPROCESSING_DIR/preprocessing/SRR6058604_scaffold_06_unpaired.1P.fastq.gz \
	$PREPROCESSING_DIR/preprocessing/SRR6058604_scaffold_06_unpaired.2P.fastq.gz \
	> unaligned_reads.sam
