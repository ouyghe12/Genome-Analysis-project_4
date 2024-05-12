#!/bin/bash -l
#SBATCH -A uppmax2024-2-7
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 30:00:00
#SBATCH -J canu_assembly
#SBATCH --mail-type=ALL
#SBATCH --mail-user wenjie.ouyang.9030@student.uu.se
#SBATCH --output=pacbio_assembly.%j.out
#SBATCH --error=pacbio_assembly.%j.err

module load bioinfo-tools
module load canu/2.2


cd $SNIC_TMP
mkdir -p ooo  
if [ $? -ne 0 ]; then
    echo "Error: Failed to create directory."
    exit 1
fi

cp /home/ouyghe/genome_analysis/Genome-Analysis-project_4/DNA_assembly/canu/SRR6037732_scaffold_06.fq ./ooo
if [ $? -ne 0 ]; then
    echo "Error: Failed to copy the file."
    exit 1
fi

echo "Starting Canu assembly at $(date)"

canu -correct \
    -p canu_assembly \
    -d $SNIC_TMP/ooo/out \
    genomeSize=50m \
    minReadLength=2000 \
    minOverlapLength=500 \
    -pacbio-raw $SNIC_TMP/ooo/SRR6037732_scaffold_06.fq \
    gridOptions="-A uppmax2024-2-7" \
    corOutCoverage=110 \
    corMinCoverage=2 \
    useGrid=false

if [ $? -ne 0 ]; then
   echo "Error in correction step."
   exit 1
fi

canu -trim \
    -p canu_assembly \
    -d $SNIC_TMP/ooo/out \
    genomeSize=50m \
    minReadLength=2000 \
    minOverlapLength=500 \
    useGrid=false \
    -pacbio-corrected $SNIC_TMP/ooo/out/canu_assembly.correctedReads.fasta.gz

if [ $? -ne 0 ]; then
   echo "Error in correction step."
   exit 1
fi

# error rate 0.035
canu -assemble \
    -p canu_assembly \
    -d $SNIC_TMP/ooo/out_0.035 \
    genomeSize=50m \
    correctedErrorRate=0.035 \
    useGrid=false \
    -pacbio-corrected $SNIC_TMP/ooo/out/canu_assembly.trimmedReads.fasta.gz
# error rate 0.050
canu -assemble \
    -p canu_assembly \
    -d $SNIC_TMP/ooo/out_0.050 \
    genomeSize=50m \
    correctedErrorRate=0.050 \
    useGrid=false \
    -pacbio-corrected $SNIC_TMP/ooo/out/canu_assembly.trimmedReads.fasta.gz

if [ $? -ne 0 ]; then
    echo "Error: Canu assembly failed."
    exit 1
fi

cp -r $SNIC_TMP/ooo/out /home/ouyghe/genome_analysis/Genome-Analysis-project_4/DNA_assembly/canu
cp -r $SNIC_TMP/ooo/out_0.035 /home/ouyghe/genome_analysis/Genome-Analysis-project_4/DNA_assembly/canu
cp -r $SNIC_TMP/ooo/out_0.050 /home/ouyghe/genome_analysis/Genome-Analysis-project_4/DNA_assembly/canu
