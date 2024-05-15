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
module load FastQC/0.11.9

LOCAL_TMP=$SNIC_TMP/oooo

cd $SNIC_TMP
mkdir -p $LOCAL_TMP
cd $LOCAL_TMP
mkdir -p fastqc_results

cp -r /proj/uppmax2024-2-7/Genome_Analysis/4_Tean_Teh_2017/transcriptome/trimmed/*_06.*.fastq.gz .
cp -r /home/ouyghe/genome_analysis/Genome-Analysis-project_4/RNA_seq/untrimm/SRR6040095_scaffold_06_paired.1.fastq.gz ./SRR6040095_scaffold_06.1.fastq.gz
cp -r /home/ouyghe/genome_analysis/Genome-Analysis-project_4/RNA_seq/untrimm/SRR6040095_scaffold_06_paired.2.fastq.gz ./SRR6040095_scaffold_06.2.fastq.gz

echo "Files in directory:"
ls -lh

for file in $LOCAL_TMP/*.fastq.gz; do
    if [ -f "$file" ]; then
        gunzip "$file"
        if [ $? -ne 0 ]; then
            echo "Error: Decompression failed for $file."
            exit 1
        fi
    else
        echo "Error: $file does not exist."
        exit 1
    fi
done

ls -lh

cat $LOCAL_TMP/*.fastq > $LOCAL_TMP/combined.fastq
if [ $? -ne 0 ]; then
    echo "Error: Combining files failed."
    exit 1
fi

ls -lh
fastqc $LOCAL_TMP/combined.fastq -o $LOCAL_TMP/fastqc_results
if [ $? -ne 0 ]; then
    echo "Error: FastQC failed."
    exit 1
fi
jellyfish count -m 21 -s 100M -t 10 -C -o $SNIC_TMP/mer_counts.jf $LOCAL_TMP/combined.fastq
if [ $? -ne 0 ]; then
    echo "Error: Jellyfish counting failed."
    exit 1
fi
cp $SNIC_TMP/mer_counts.jf $LOCAL_TMP/


jellyfish histo -o $LOCAL_TMP/kmer_histogram.txt $LOCAL_TMP/mer_counts.jf
if [ $? -ne 0 ]; then
    echo "Error: Jellyfish histogram failed."
    exit 1
fi

cat <<EOF >samples.txt
cond_A    cond_A_rep1    SRR6040095_scaffold_06.1.fastq    SRR6040095_scaffold_06.2.fastq
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
done <$LOCAL_TMP/samples.txt

Trinity --seqType fq \
        --samples_file $LOCAL_TMP/samples.txt \
        --CPU 8 \
        --max_memory 100G \
        --output $LOCAL_TMP/trinity_out \
        --no_normalize_reads \
        --verbose
if [ $? -ne 0 ]; then
    echo "Error: Trinity failed for rna."
    exit 1
fi

cp -r $LOCAL_TMP/trinity_out /proj/uppmax2024-2-7/nobackup/work/ouyghe_work
if [ $? -ne 0 ]; then
    echo "Error: Copying results failed."
    exit 1
fi
