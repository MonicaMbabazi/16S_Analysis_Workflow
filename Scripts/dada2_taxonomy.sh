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

## Define the Results/Output directory
RESULTS_DIR="absolute-path-output-dir"

# 1. Assume you run your entire dataset as a single dataset. Meaning you imported one manifest file and you have one demux.qza file
## Run DADA2 using the code below
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs ${RESULTS_DIR}/demux.qza \
  --o-table ${RESULTS_DIR}/table-dada.qza \
  --o-representative-sequences ${RESULTS_DIR}/rep-seqs-dada.qza \
  --o-denoising-stats ${RESULTS_DIR}/stats-dada.qza \
  --p-trim-left-f 5 \
  --p-trim-left-r 5 \
  --p-trunc-len-r 220 \
  --p-trunc-len-f 220 \
  --p-n-threads 6

# 2. If you ran your data in batches. Assume you have 15 batches. So, we have to run dada2 on each batch and then after merge dada2 outputs
## Run DADA2 on 15 batches using the code below
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs ${RESULTS_DIR}/demux_"${BatchN}".qza \
  --o-table ${RESULTS_DIR}/table-dada_"${BatchN}".qza \
  --o-representative-sequences ${RESULTS_DIR}/rep-seqs-dada_"${BatchN}".qza \
  --o-denoising-stats ${RESULTS_DIR}/stats-dada_"${BatchN}".qza \
  --p-trim-left-f 5 \
  --p-trim-left-r 5 \
  --p-trunc-len-r 220 \
  --p-trunc-len-f 220 \
  --p-n-threads 6

## Merging dada2 output files: 1. table files,  2.representative sequence files 

# Collect all table files using a wildcard
qiime feature-table merge \
  --i-tables $(ls ${RESULTS_DIR}/table-dada_*.qza | tr '\n' ' ') \
  --o-merged-table ${RESULTS_DIR}/table-dada.qza

# Collect all rep-seqs files using a wildcard 
qiime feature-table merge-seqs \
  --i-data $(ls ${RESULTS_DIR}/rep-seqs-dada_*.qza | tr '\n' ' ') \
  --o-merged-data ${RESULTS_DIR}/rep-seqs-dada.qza

############################################################################# End of DADA2 step #################################################################

#  Note: After DADA2 step you follow the same steps below, whether the dataset was run as one batch or in many batches.

#################################################################################### Phylogenetic analysis 
# This step takes in  dada2 output 
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences ${RESULTS_DIR}/rep-seqs-dada.qza \
  --o-alignment ${RESULTS_DIR}/aligned-rep-seqs.qza \
  --o-masked-alignment ${RESULTS_DIR}/masked-aligned-rep-seqs.qza \
  --o-tree ${RESULTS_DIR}/unrooted-tree.qza \
  --o-rooted-tree ${RESULTS_DIR}/rooted-tree.qza

#################################################################################### Alpha and Beta Diversity  
# The input files are: rooted-tree.qza and table-dada.qza
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ${RESULTS_DIR}/rooted-tree.qza \
  --i-table ${RESULTS_DIR}/table-dada.qza \
  --p-sampling-depth 5000 \ # set the sampling depth depending on read depth of your dataset
  --m-metadata-file /absolute-path/metadata.tsv \
  --output-dir ${RESULTS_DIR}/core-metrics-results

#### Alpha rarefaction
qiime diversity alpha-rarefaction \
  --i-table ${RESULTS_DIR}/table-dada.qza \
  --i-phylogeny ${RESULTS_DIR}/rooted-tree.qza \
  --p-max-depth 10000 \
  --m-metadata-file /absolute-path/metadata.tsv \
  --o-visualization ${RESULTS_DIR}/alpha-rarefaction.qzv

##################################################################################### Taxonomic assignment
## Using the classifier that I trained
qiime feature-classifier classify-sklearn \
  --i-classifier /absolute-path/classifier.qza \
  --i-reads ${RESULTS_DIR}/rep-seqs-dada.qza \
  --o-classification ${RESULTS_DIR}/taxonomy.qza

### Visualize the taxonomy output
qiime metadata tabulate \
  --m-input-file ${RESULTS_DIR}/taxonomy.qza \
  --o-visualization ${RESULTS_DIR}/taxonomy.qzv

#### Taxa barplot
qiime taxa barplot \
  --i-table ${RESULTS_DIR}/table-dada.qza \
  --i-taxonomy ${RESULTS_DIR}/taxonomy.qza \
  --m-metadata-file /absolute-path/metadata.tsv \
  --o-visualization ${RESULTS_DIR}/taxa-bar-plots.qzv

################################################################################# End  ##############################################################################

### Important files required to generate phyloseq object
# 1. table-dada.qza
# 2. rooted-tree.qza
# 3. taxonomy.qza
# 4. metadata.tsv

#####  To be imported in R for downstream analysis
#####################################################################################################################################################################
