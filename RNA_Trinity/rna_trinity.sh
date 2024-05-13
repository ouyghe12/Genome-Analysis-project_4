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

cd $SNIC_TMP

mkdir -p oooo
cd oooo
cp -r /proj/uppmax2024-2-7/Genome_Analysis/4_Tean_Teh_2017/transcriptome/trimmed/*_06.*.fastq.gz .
cp -r /home/ouyghe/genome_analysis/Genome-Analysis-project_4/RNA_seq/untrimm/SRR6040095_scaffold_06_paired.1.fastq.gz ./SRR6004095_scaffold_06.1.fastq.gz
cp -r /home/ouyghe/genome_analysis/Genome-Analysis-project_4/RNA_seq/untrimm/SRR6040095_scaffold_06_paired.2.fastq.gz ./SRR6004095_scaffold_06.2.fastq.gz

echo "Files in directory:"
ls -lh

gunzip *.fastq.gz
if [ $? -ne 0 ]; then
    echo "Error: Decompression failed."
    exit 1
fi

ls -lh

cat *.fastq > combined.fastq
if [ $? -ne 0 ]; then
    echo "Error: Combining files failed."
    exit 1
fi

ls -lh

jellyfish count -m 21 -s 100M -t 10 -C -o ./mer_counts.jf combined.fastq
if [ $? -ne 0 ]; then
    echo "Error: Jellyfish counting failed."
    exit 1
fi
jellyfish histo -o ./kmer_histogram.txt ./mer_counts.jf
if [ $? -ne 0 ]; then
    echo "Error: Jellyfish histogram failed."
    exit 1
fi

cat <<EOF >samples.txt
cond_A    cond_A_rep1    SRR6004095_scaffold_06.1.fastq    SRR6004095_scaffold_06.2.fastq
cond_A    cond_A_rep2    SRR6040092_scaffold_06.1.fastq    SRR6040092_scaffold_06.2.fastq
cond_A    cond_A_rep3    SRR6040093_scaffold_06.1.fastq    SRR6040093_scaffold_06.2.fastq
cond_A    cond_A_rep4    SRR6040094_scaffold_06.1.fastq    SRR6040094_scaffold_06.2.fastq
cond_A    cond_A_rep5    SRR6040096_scaffold_06.1.fastq    SRR6040096_scaffold_06.2.fastq
cond_A    cond_A_rep6    SRR6040097_scaffold_06.1.fastq    SRR6040097_scaffold_06.2.fastq
cond_B    cond_B_rep1    SRR6156066_scaffold_06.1.fastq    SRR6156066_scaffold_06.2.fastq
cond_B    cond_B_rep2    SRR6156067_scaffold_06.1.fastq    SRR6156067_scaffold_06.2.fastq
cond_B    cond_B_rep3    SRR6156069_scaffold_06.1.fastq    SRR6156069_scaffold_06.2.fastq
EOF

while read line; do
    for file in $(echo $line | awk '{print $3, $4}'); do
        if [ ! -f "$file" ]; then
            echo "Error: Missing file $file"
            exit 1
        fi
    done
done <samples.txt

Trinity --seqType fq \
        --samples_file samples.txt \
        --CPU 8 \
        --max_memory 100G \
        --output trinity_out \
        --no_normalize_reads

if [ $? -ne 0 ]; then
    echo "Error: Trinity failed for rna."
    exit 1
fi

cp -r trinity_out /proj/uppmax2024-2-7/nobackup/work/ouyghe_work

