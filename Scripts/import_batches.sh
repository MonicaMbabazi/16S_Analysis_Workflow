#!/bin/bash
## This script is for batch one and it has eight samples

### Setting qsub parameters
#$ -cwd
#$ -l h_rt=48:00:00
#$ -l h_vmem=10G
#$ -N Import_batches
#$ -pe sharedmem 1
#$ -R y
#$ -m be -M M.Mbabazi@sms.ed.ac.uk
#$ -P roslin_muwonge_fellowship

. /etc/profile.d/modules.sh

### Load modules
module load anaconda/2024.02
conda activate qiime2-amplicon-2024.5

BatchN=$1
### Importing Data Into Qiime2

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path /exports/eddie/scratch/s2000755/Qiime2/manifest_batches/manifest_batch_"${BatchN}".tsv \
  --output-path /exports/eddie/scratch/s2000755/Qiime2/Results/demux_"${BatchN}".qza \
  --input-format PairedEndFastqManifestPhred33V2


######################### RUNNING DADA2 PER SAMPLE OR PER BATCH

#### Dada2 on all the batches (5)
#qiime dada2 denoise-paired \
#  --i-demultiplexed-seqs /exports/eddie/scratch/s2000755/Qiime/batch_results/demux_"$BatchN".qza \
#  --o-table /exports/eddie/scratch/s2000755/Qiime/batch_results/table-dada2_"$BatchN".qza \
#  --o-representative-sequences /exports/eddie/scratch/s2000755/Qiime/batch_results/rep-seqs-dada2_"$BatchN".qza \
#  --o-denoising-stats /exports/eddie/scratch/s2000755/Qiime/batch_results/stats-dada2_"$BatchN".qza \
#  --p-trim-left-f 0 \
#  --p-trim-left-r 0 \
#  --p-trunc-len-r 0 \
#  --p-trunc-len-f 0 \
#  --p-n-threads 16
