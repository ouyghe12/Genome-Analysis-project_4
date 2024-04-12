#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 04:00:00
#SBATCH -J pacbio_assembly
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=pacbio_assembly.%j.out
#SBATCH --error=pacbio_assembly.%j.err
# Load modules
module load bioinfo-tools
module load Flye/2.9.1
# Your commands
flye --pacbio-raw /home/ouyghe/genome_analysis/Genome-Analysis-project_4/PacBio/SRR6037732_scaffold_06.fq.gz \
     --out-dir /home/ouyghe/genome_analysis/Genome-Analysis-project_4/DNA_assembly \
     --genome-size 27.39g \
     --threads 4 
