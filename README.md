# A Harmonized Pipeline for 16S Amplicon Analysis of Global Tuberculosis Microbiome Data
Table of Contents
* [Workflow overview](#workflow-overview)
* [Installation and HPC Usage](#Installation-and-HPC-Usage)
* [Upstream Analysis using Qiime2 and DADA2](#Upstream-Analysis-using-Qiime2-and-DADA2)
* [Downstream Analysis using phyloseq](#Downstream-Analysis-using-phyloseq)
* [References](#references)
## The pipeline is currently under active development

## Workflow Overview
This repository serves as the first publicly available framework dedicated to a **global-scale microbiome meta-analysis of tuberculosis (TB) studies**. Our goal is to provide a **standardized, reproducible, and well-documented pipeline** for processing and analyzing 16S rRNA amplicon sequencing data from diverse TB microbiome studies across different geographic regions. This repository is designed to help researchers harmonize datasets, apply consistent analytical methods, and derive meaningful insights into the microbial communities associated with TB. This repository is intended for **microbiome researchers, bioinformaticians, epidemiologists, and clinicians** interested in TB-associated microbial communities.
### Key Features of this Repository
+ **Standardized Workflow** – A harmonized pipeline for pre-processing, filtering, taxonomic classification, and statistical analysis.
+ **Global Meta-Analysis** – The first repository to integrate TB microbiome datasets from multiple studies worldwide.
+ **Scalable Execution** – Designed for HPC clusters like EDDIE, but adaptable to other computing environments.
+ **Reproducibility** – All scripts and steps are well-documented for easy replication and adaptation.
+ **Biological Insights** – Provides tools to explore microbial diversity, composition, and potential associations with TB.

### Insert in workflow diagram
### Dataset (Input files) Description
This repository is built on a global microbiome meta-analysis framework, integrating data from multiple tuberculosis microbiome studies. Due to the large size of raw sequencing files (**FASTQ files**), we provide a **ready-to-use processed dataset** while also allowing users to retrieve and process the original raw data if needed.
#### Available Datasets
##### Global Microbiome Meta-Analysis Dataset
**`Global_Dataset.zip`**
This zipped file provides two options for running the pipeline:
**Global Phyloseq Object** (`phyloseq_obj.rds`)

```
1. paired fastq files
2. Metadata: This should be verified using Keemei and should be in tsv format
3. Global_Dataset.zip
```
## Installation and HPC Usage
All job scripts and analysis workflows have been designed and executed on the Eddie server (University of Edinburgh High-Performance Computing Cluster). However,the pipeline is **flexible and can be adapted to run on any other HPC cluster** with minor modifications.
#### Tools to be installed:
```
1. Qiime2
2. Phyloseq. It is an R package
```
Link to install qiime2 [here](https://docs.qiime2.org/2024.10/install/)

## Upstream Analysis using Qiime2 and DADA2

#### Key steps:
1. Data processing,Importation , and QC
2. Denoising and Clustering Analysis using DADA2: Generating a feature table (ASV file).
3. Taxonomy and Phylogeny Analysis
4. Output files
   
##### 1). Data processing, generating a manifest file, and importation

## Downstream Analysis using phyloseq

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

