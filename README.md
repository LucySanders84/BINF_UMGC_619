# RNA-seq Pipeline Project

## Overview

This project implements an RNA-seq analysis pipeline including:

* Quality control
* Read trimming
* Alignment
* Gene quantification
* Visualization

The pipeline is implemented using Bash scripts and organized for reproducibility.

---

## Project Structure

```
rna_seq_pipeline/
├── data/           # raw, trimmed, and reference data
├── scripts/        # pipeline scripts
├── results/        # output files and results
├── environment/    # conda environment file
├── docs/           # figures for report
└── logs/           # execution logs
```

---

## Setup

Create the conda environment:

```
conda env create -f environment.yml
```

Activate the environment:

```
conda activate rna_seq_pipeline
```

---

## Download Data
The pipeline runs with any paired-end RNA-Seq .fastq files, a microbial genome .fasta file and .gff annotation file. 
## Running the Pipeline

Run the full pipeline:

```
bash scripts/run_pipeline.sh {project_name} {data_directory} {project_destination_directory
```

---

## Pipeline Steps

1. **Download Data**
   Retrieve RNA-seq FASTQ files from NCBI SRA.

2. **Quality Control**
   Assess read quality using FastQC and MultiQC.

3. **Read Cleaning**
   Trim adapters and low-quality bases.

4. **Alignment**
   Align reads to reference genome.

5. **Quantification**
   Generate gene expression counts.

6. **Visualization**
   Create plots and heatmaps of expression data.

---

## Outputs

Results are stored in the `results/` directory:

* QC reports
* Trimmed reads
* Alignment metrics
* Gene counts
* Plots and figures

---
## Example Pipeline Run
This repository provides an example of the pipeline using the Pseudomonas Aeruginosa genome and RNA sequencing data. 

To run the example:

```commandline
bash run_PAO1_pipeline.sh
```
---

## Notes

* All scripts are located in the `scripts/` directory.
* The pipeline assumes required tools are installed via the conda environment.
* Logs for each step can be found in the `logs/` directory.

---

## Contributors

* Amir Sadeghi
* Lucy Sanders
