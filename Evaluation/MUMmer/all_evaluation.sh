#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 10:00:00
#SBATCH -J evaluation
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=evaluation.%j.out
#SBATCH --error=evaluation.%j.err

module load bioinfo-tools
module load MUMmer/4.0.0rc1

PREPROCESSING_DIR="/home/ouyghe/genome_analysis/Genome-Analysis-project_4"
flyeDir=$PREPROCESSING_DIR/DNA_assembly/flye/assembly.fasta
modified_flyeDir=$PREPROCESSING_DIR/DNA_assembly/modified_flye/assembly.fasta
pilonDir=$PREPROCESSING_DIR/DNA_assembly/pilon/pilon.fasta
canu35Dir=$PREPROCESSING_DIR/DNA_assembly/canu/out_0.035/canu_assembly.contigs.fasta
canu5Dir=$PREPROCESSING_DIR/DNA_assembly/canu/out_0.050/canu_assembly.contigs.fasta

nucmer --prefix=f_vs_p $flyeDir $pilonDir
nucmer --prefix=f_vs_mf $flyeDir $modified_flyeDir
nucmer --prefix=f_vs_c3 $flyeDir $canu35Dir
nucmer --prefix=f_vs_c5 $flyeDir $canu5Dir
nucmer --prefix=p_vs_mf $pilonDir $canu5Dir
nucmer --prefix=p_vs_c3 $pilonDir $canu35Dir
nucmer --prefix=p_vs_c5 $pilonDir $canu5Dir
nucmer --prefix=mf_vs_c3 $modified_flyeDir $canu35Dir
nucmer --prefix=mf_vs_c5 $modified_flyeDir $canu5Dir
nucmer --prefix=c3_vs_c5 $canu35Dir $canu5Dir

mummerplot --png --prefix=f_vs_p --filter --color --layout --coverage --large f_vs_p.delta
mummerplot --png --prefix=f_vs_mf --filter --color --layout --coverage --large f_vs_mf.delta
mummerplot --png --prefix=f_vs_c3 --filter --color --layout --coverage --large f_vs_c3.delta
mummerplot --png --prefix=f_vs_c5 --filter --color --layout --coverage --large f_vs_c5.delta
mummerplot --png --prefix=p_vs_mf --filter --color --layout --coverage --large p_vs_mf.delta
mummerplot --png --prefix=p_vs_c3 --filter --color --layout --coverage --large p_vs_c3.delta
mummerplot --png --prefix=p_vs_c5 --filter --color --layout --coverage --large p_vs_c5.delta
mummerplot --png --prefix=mf_vs_c3 --filter --color --layout --coverage --large mf_vs_c3.delta
mummerplot --png --prefix=mf_vs_c5 --filter --color --layout --coverage --large mf_vs_c5.delta
mummerplot --png --prefix=c3_vs_c5 --filter --color --layout --coverage --large c3_vs_c5.delta