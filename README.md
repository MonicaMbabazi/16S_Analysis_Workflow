# 16S_Analysis_Workflow
This workflow has step by step instructions and scripts to 16S microbiome analysis.
- Table of Contents
[Workflow Overview](#Workflow-Overview)


## Workflow Overview

### Key steps, Input files, Required tools/packages
#### Input files:
```
1. paired fastq files
2. Metadata: This should be verified using Keemei and should be in tsv format
```

#### Tools to be installed:
```
1. Qiime2
2. Phyloseq. It is an R package
```
Link to install qiime2 [here](https://docs.qiime2.org/2024.5/install/index.html)
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


