#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 04:00:00
#SBATCH -J evaluation
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=evaluation.%j.out
#SBATCH --error=evaluation.%j.err

module load bioinfo-tools
module load BUSCO/5.5.0
module load augustus/3.5.0-20231223-33fc04d
module load perl/5.32.1
module load perl_modules/5.32.1

source $AUGUSTUS_CONFIG_COPY
export AUGUSTUS_CONFIG_PATH=$(pwd)/augustus_config
chmod a+w -R $AUGUSTUS_CONFIG_PATH/species

PREPROCESSING_DIR="/home/ouyghe/genome_analysis/Genome-Analysis-project_4/"
busco -i $PREPROCESSING_DIR/DNA_assembly/flye/assembly.fasta \
    -o flye_busco -l $BUSCO_LINEAGE_SETS/embryophyta_odb10 -m geno -f
busco -i $PREPROCESSING_DIR/DNA_assembly/modified_flye/assembly.fasta \
    -o modified_flye_busco -l $BUSCO_LINEAGE_SETS/embryophyta_odb10 -m geno -f
busco -i $PREPROCESSING_DIR/DNA_assembly/pilon/pilon.fasta \
    -o pilon_busco -l $BUSCO_LINEAGE_SETS/embryophyta_odb10 -m geno -f
busco -i /home/ouyghe/genome_analysis/Genome-Analysis-project_4/DNA_assembly/canu/out_0.035/canu_assembly.contigs.fasta \
    -o canu_0.035_busco -l $BUSCO_LINEAGE_SETS/embryophyta_odb10 -m geno -f
busco -i /home/ouyghe/genome_analysis/Genome-Analysis-project_4/DNA_assembly/canu/out_0.050/canu_assembly.contigs.fasta \
    -o canu_0.05_busco -l $BUSCO_LINEAGE_SETS/embryophyta_odb10 -m geno -f