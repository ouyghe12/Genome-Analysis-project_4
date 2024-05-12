#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 10:00:00
#SBATCH -J pacbio_assembly
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=pacbio_assembly.%j.out
#SBATCH --error=pacbio_assembly.%j.err
# Load modules
module load bioinfo-tools
module load Flye/2.9.1
module load Filtlong

INPUT_PATH=/home/ouyghe/genome_analysis/Genome-Analysis-project_4/PacBio/SRR6037732_scaffold_06.fq.gz

filtlong --min_length 1000 --keep_percent 90 $INPUT_PATH > ./SRR6037732_scaffold_06_filter.fq

gzip ./SRR6037732_scaffold_06_filter.fq

flye --pacbio-raw ./SRR6037732_scaffold_06_filter.fq.gz \
     --out-dir . \
     --genome-size 27.39g \
     --threads 8 \
     --min-overlap 5000