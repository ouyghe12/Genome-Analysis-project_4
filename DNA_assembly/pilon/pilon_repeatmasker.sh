#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 20:00:00
#SBATCH -J pilon_repeatmasker
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=pilon_repeatmasker.%j.out
#SBATCH --error=pilon_repeatmasker.%j.err

module load bioinfo-tools
module load RepeatMasker/4.1.5
module load hmmer/3.2.1

RepeatMasker -species plants -pa 4 -html -gff -engine ncbi pilon.fasta



