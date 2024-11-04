#!/bin/bash

## This script is for running DADA2, do phylogeny, and taxonomic assignment
## Important files needed for this script: 1. demux.qza and  2. Verified metadata in a tsv format

### Setting qsub parameters
#$ -cwd
#$ -l h_rt=48:00:00
#$ -l h_vmem=10G
#$ -N DADA2_Taxonomy
#$ -pe sharedmem 6
#$ -R y
#$ -m be -M M.Mbabazi@sms.ed.ac.uk 
#$ -P roslin_muwonge_fellowship

. /etc/profile.d/modules.sh

### Load modules
module load anaconda/2024.02
conda activate qiime2-amplicon-2024.5

# 1. Assume you run your entire dataset as a single dataset. Meaning you imported one manifest file and you have one demux.qza file
## Run DADA2 using the code below
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs /absolute-path-output-dir/demux.qza \
  --o-table /absolute-path-output-dir/table-dada.qza \
  --o-representative-sequences /absolute-path-output-dir/rep-seqs-dada.qza \
  --o-denoising-stats /absolute-path-output-dir/stats-dada.qza \
  --p-trim-left-f 5 \
  --p-trim-left-r 5 \
  --p-trunc-len-r 220 \
  --p-trunc-len-f 220 \
  --p-n-threads 6

# 2. If you ran your data in batches. Assume you have 15 batches. So, we have to run dada2 on each batch and then after merge dada2 outputs

## Merging dada2 table
#DADA2_DIR="/exports/eddie/scratch/s2000755/Meta-analysis/Results"

# Collect all table files using a wildcard for SGE_TASK_ID
#qiime feature-table merge \
 # --i-tables $(ls ${DADA2_DIR}/table-dada_*.qza | tr '\n' ' ') \
 # --o-merged-table ${DADA2_DIR}/merged-table.qza

# Collect all rep-seqs files using a wildcard for SGE_TASK_ID
#qiime feature-table merge-seqs \
 # --i-data $(ls ${DADA2_DIR}/rep-seqs-dada_*.qza | tr '\n' ' ') \
 # --o-merged-data ${DADA2_DIR}/merged-rep-seqs.qza

######################################### AFTER MERGING #######################################################

######################## Diversity analysis of the merged data #########################
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences /exports/eddie/scratch/s2000755/Meta-analysis/Results/merged-rep-seqs.qza \
  --o-alignment /exports/eddie/scratch/s2000755/Meta-analysis/Results/aligned-rep-seqs_merged.qza \
  --o-masked-alignment /exports/eddie/scratch/s2000755/Meta-analysis/Results/masked-aligned-rep-seqs_merged.qza \
  --o-tree /exports/eddie/scratch/s2000755/Meta-analysis/Results/unrooted-tree_merged.qza \
  --o-rooted-tree /exports/eddie/scratch/s2000755/Meta-analysis/Results/rooted-tree_merged.qza

###### Alpha and Beta Diversity #####################################
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny /exports/eddie/scratch/s2000755/Meta-analysis/Results/rooted-tree_merged.qza \
  --i-table /exports/eddie/scratch/s2000755/Meta-analysis/Results/merged-table.qza \
  --p-sampling-depth 5000 \
  --m-metadata-file /exports/eddie/scratch/s2000755/Meta-analysis/combined_metadata.tsv \
  --output-dir /exports/eddie/scratch/s2000755/Meta-analysis/Results/core-metrics-results_merged

#### Alpha rarefaction
qiime diversity alpha-rarefaction \
  --i-table /exports/eddie/scratch/s2000755/Meta-analysis/Results/merged-table.qza \
  --i-phylogeny /exports/eddie/scratch/s2000755/Meta-analysis/Results/rooted-tree_merged.qza \
  --p-max-depth 10000 \
  --m-metadata-file /exports/eddie/scratch/s2000755/Meta-analysis/combined_metadata.tsv \
  --o-visualization /exports/eddie/scratch/s2000755/Meta-analysis/Results/alpha-rarefaction_merged.qzv

##### Taxonomic assignment
qiime feature-classifier classify-sklearn \
  --i-classifier /exports/eddie/scratch/s2000755/Meta-analysis/silva-138.1-full-nr99-classifier.qza \
  --i-reads /exports/eddie/scratch/s2000755/Meta-analysis/Results/merged-rep-seqs.qza \
  --o-classification /exports/eddie/scratch/s2000755/Meta-analysis/Results/taxonomy_merged.qza

qiime metadata tabulate \
  --m-input-file /exports/eddie/scratch/s2000755/Meta-analysis/Results/taxonomy_merged.qza \
  --o-visualization /exports/eddie/scratch/s2000755/Meta-analysis/Results/taxonomy_merged.qzv

#### Taxa barplot
qiime taxa barplot \
  --i-table /exports/eddie/scratch/s2000755/Meta-analysis/Results/merged-table.qza \
  --i-taxonomy /exports/eddie/scratch/s2000755/Meta-analysis/Results/taxonomy_merged.qza \
  --m-metadata-file /exports/eddie/scratch/s2000755/Meta-analysis/combined_metadata.tsv \
  --o-visualization /exports/eddie/scratch/s2000755/Meta-analysis/Results/taxa-bar-plots_merged.qzv
