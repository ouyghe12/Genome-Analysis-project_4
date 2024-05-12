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
module load REAPR/1.0.18
module load perl/5.24.1
module load perl_modules/5.24.1
module load bamtools/2.5.2
module load gcc/13.2.0

export LD_LIBRARY_PATH=/sw/bioinfo/bamtools/2.5.2/snowy/lib:$LD_LIBRARY_PATH
if [ ! -L /sw/bioinfo/bamtools/2.5.2/snowy/lib/libbamtools.so.2.1.0 ]; then
    ln -s /sw/bioinfo/bamtools/2.5.2/snowy/lib/libbamtools.so.2.5.2 /sw/bioinfo/bamtools/2.5.2/snowy/lib/libbamtools.so.2.1.0
fi
PREPROCESSING_DIR="/home/ouyghe/genome_analysis/Genome-Analysis-project_4"
flyeDir=$PREPROCESSING_DIR/DNA_assembly/flye/assembly.fasta
modified_flyeDir=$PREPROCESSING_DIR/DNA_assembly/modified_flye/assembly.fasta
pilonDir=$PREPROCESSING_DIR/DNA_assembly/pilon/pilon.fasta
bamDir=$PREPROCESSING_DIR/Align/sorted_output.bam
canu35Dir=$PREPROCESSING_DIR/DNA_assembly/canu/out_0.035/canu_assembly.contigs.fasta
canu5Dir=$PREPROCESSING_DIR/DNA_assembly/canu/out_0.050/canu_assembly.contigs.fasta


reapr facheck $flyeDir $PREPROCESSING_DIR/Evaluation/reapr/flye/assembly.checked
reapr pipeline $PREPROCESSING_DIR/Evaluation/reapr/flye/assembly.checked.fa $bamDir $PREPROCESSING_DIR/Evaluation/reapr/flye/out

reapr facheck $modified_flyeDir $PREPROCESSING_DIR/Evaluation/reapr/modified_flye/assembly.checked
reapr pipeline $PREPROCESSING_DIR/Evaluation/reapr/modified_flye/assembly.checked.fa $bamDir $PREPROCESSING_DIR/Evaluation/reapr/modified_flye/out

reapr facheck $pilonDir $PREPROCESSING_DIR/Evaluation/reapr/pilon/assembly.checked
reapr pipeline $PREPROCESSING_DIR/Evaluation/reapr/pilon/assembly.checked.fa $bamDir $PREPROCESSING_DIR/Evaluation/reapr/pilon/out

reapr facheck $canu35Dir $PREPROCESSING_DIR/Evaluation/reapr/canu_0.035/assembly.checked
reapr pipeline $PREPROCESSING_DIR/Evaluation/reapr/canu_0.035/assembly.checked.fa $bamDir $PREPROCESSING_DIR/Evaluation/reapr/canu_0.035/out

reapr facheck $canu5Dir $PREPROCESSING_DIR/Evaluation/reapr/canu_0.05/assembly.checked
reapr pipeline $PREPROCESSING_DIR/Evaluation/reapr/canu_0.05/assembly.checked.fa $bamDir $PREPROCESSING_DIR/Evaluation/reapr/canu_0.05/out