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

/sw/bioinfo/trinity/2.14.0/rackham/util/support_scripts/filter_transcripts_require_min_cov.pl ./Trinity.tmp.fasta ./both.fa ./salmon_outdir/quant.sf 2 > ./trinity_out.Trinity.fasta
/sw/bioinfo/trinity/2.14.0/rackham/util/support_scripts/get_Trinity_gene_to_trans_map.pl ./trinity_out.Trinity.fasta > ./trinity_out.Trinity.fasta.gene_trans_map