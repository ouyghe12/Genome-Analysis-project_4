#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 20:00:00
#SBATCH -J RNA_assembly
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=RNA_assembly.%j.out
#SBATCH --error=RNA_assembly.%j.err


module load bioinfo-tools
module load trinity/2.14.0
module load jellyfish/2.3.0

/sw/bioinfo/trinity/2.14.0/rackham/util/TrinityStats.pl ./Trinity.tmp.fasta > Stat.txt