#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 20:00:00
#SBATCH -J RNA_Pilon_annotation
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=RNA_Pilon_annotation.%j.out
#SBATCH --error=RNA_Pilon_annotation.%j.err

module load bioinfo-tools
module load augustus/3.2.3_Perl5.24.1
module load bamtools/2.5.1
module load blast/2.9.0+
module load GenomeThreader/1.7.0
module load samtools/1.8
module load GeneMark/4.33-es_Perl5.24.1
module load braker/2.1.1_Perl5.24.1

source $AUGUSTUS_CONFIG_COPY
export AUGUSTUS_CONFIG_PATH=$(pwd)/augustus_config
chmod a+w -R $AUGUSTUS_CONFIG_PATH/species

cp -vf /sw/bioinfo/GeneMark/4.33-es/snowy/gm_key $HOME/.gm_key

export AUGUSTUS_BIN_PATH=/sw/bioinfo/augustus/3.4.0/snowy/bin
export AUGUSTUS_SCRIPTS_PATH=/sw/bioinfo/augustus/3.4.0/snowy/scripts
export GENEMARK_PATH=/sw/bioinfo/GeneMark/4.33-es/snowy

genomeDir=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/DNA_assembly/pilon/pilon.fasta.masked
rnaDir=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/Align/RNA_Pilon/merged.bam

braker.pl --genome=$genomeDir --bam=$rnaDir --species=Durio_zibethinus --softmasking --useexisting

