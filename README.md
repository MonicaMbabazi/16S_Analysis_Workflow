# 16S Analysis Workflow
Table of Contents
* [Workflow overview](#workflow-overview)
* [Installation and HPC Usage](#Installation-and-HPC-Usage)
* [Data Processing, Importation, and QC](#Data-Processing,-Importation,-and-QC)
* [Denoising and Clustering Analysis using DADA2](#Denoising-and-Clustering-Analysis-Using-DADA2)
* [Taxonomy and Phylogeny Analysis](Taxonomy-and-Phylogeny-Analysis)
* [Downstream Analysis with Phyloseq](Downstream-Analysis-with-Phyloseq)
* [References](#references)
## The pipeline is currently under active development

## Workflow Overview
This workflow has step by step instructions and scripts to 16S microbiome analysis of a TB dataset.
#### Insert in workflow diagram
#### Input files:
```
1. paired fastq files
2. Metadata: This should be verified using Keemei and should be in tsv format
```
## Installation and HPC Usage
#### Tools to be installed:
```
1. Qiime2
2. Phyloseq. It is an R package
```
Link to install qiime2 [here](https://docs.qiime2.org/2024.10/install/)
## Data Processing, Importation, and QC
#### Key steps:
##### A). Upstream Analysis using Qiime2
1. Generating a manifest file and importing data into qiime2
2. Qaulity control to remove poor quality reads, adapters, chimeric reads etc
3. Generating a feature table (ASV file).
4. Phylogeny and Taxonomic analysis

##### B). Downstream Analysis using phyloseq
1. Data importation, Exploration, and quality check
2. Alpha Diversity analysis
3. Beta diversity analysis
4. PERMANOVA and CAP

### Note: Define file outputs from qiime
1. ASV table
2. Rooted tree
3. Taxonomy file
4. Representative sequences
5. Metadata

## References

