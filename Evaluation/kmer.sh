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
module load jellyfish/2.3.0

LOCAL_TMP=$SNIC_TMP/ouy

cd $SNIC_TMP
mkdir -p $LOCAL_TMP
cd $LOCAL_TMP

cp -r /proj/uppmax2024-2-7/Genome_Analysis/4_Tean_Teh_2017/pacbio_data/SRR6037732_scaffold_06.fq.gz .

gunzip SRR6037732_scaffold_06.fq.gz

jellyfish count -m 21 -s 100M -t 10 -C -o $SNIC_TMP/mer_counts.jf $LOCAL_TMP/SRR6037732_scaffold_06.fq
cp $SNIC_TMP/mer_counts.jf $LOCAL_TMP/
jellyfish histo -o $LOCAL_TMP/kmer_histogram.txt $LOCAL_TMP/mer_counts.jf
cp -r kmer_histogram.txt /home/ouyghe/genome_analysis/Genome-Analysis-project_4/Evaluation