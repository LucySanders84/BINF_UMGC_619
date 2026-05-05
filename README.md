# Microbial RNA-seq Pipeline Project

## Overview

This project implements a microbial RNA-seq analysis pipeline including:

* Quality control
* Read trimming
* Alignment
* Gene quantification
* Visualization

The pipeline utilizes Bash and Python scripts and is organized for reproducibility.

Contributors performed an analysis of microbial RNA-seq samples from pseudomonas aeruginosa using the pipeline 
in a top-level execution script (`run_PAO1_pipeline.sh`). The execution can be replicated by running this script.
 
The results and reports from the analysis are available in the PAO1_example/PAO1 directory. 



---

## Pipeline Structure

```
rna_seq_pipeline/
├── scripts/               # pipeline scripts
├── environment.yml        # yaml file for environment setup
├── README.md              
└── run_PAO1_pipeline.sh   # script to run pipeline with PAO1 dataset
```

---

## Project Structure
The pipeline creates a project with the following structure:
```
project_title/
├── data/           # aligned, raw, trimmed, and reference data
├── logs/           # output logs
├── reports/        # output reports
└── results/        # output files and results
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

## Downloading Data
The pipeline runs with any paired-end RNA-Seq .fastq files, a microbial genome .fasta file and .gff annotation file. 
So the pipeline can be utilized with pre-downloaded data, the download data step is decoupled from the rest of the pipeline. 
The `run_pipeline.sh` script assumes RNA-seq data, genome reference and annotation files are already available locally.
Users can obtain .fastq files by running `scripts/01_download_data.sh [SRR IDs]`. 

`01_download_data.sh` retrieves RNA-seq FASTQ files from NCBI SRA.
   
   Tools
   - prefetch
   - fasterq-dump

---
## Running the Pipeline

Run the pipeline with the following arguments:
1. **Project name:** An identifier for the project
2. **Data directory:** The location of the RNA-seq .fastq files, genome reference and annotation file
3. **Project destination:** The directory which will contain the output files after completion 

Run the full pipeline:

```
bash scripts/run_pipeline.sh [project_name] [data_directory] [project_destination_directory]
```

---

## Pipeline Steps

1. **Quality Control**
   Assess read quality using FastQC and MultiQC.
   
   Tools
   - fastQC


2. **Read Cleaning**
   Trim adapters and low-quality bases.
   
   Tools
   - fastp


3. **Alignment**
   Align reads to reference genome.
   
   Tools
   - hisat2
   - samtools


4. **Quantification**
   Generate gene expression counts.
   
   Tools
   - featurecounts


5. **Visualization**
   Create tables, plots and heatmaps of expression data.
   
   Tools
   - multiQC
   - pandas
   - matplotlib

---

## Outputs

Results from pipeline tools are stored in the `results/` directory:

* QC reports
* Trimmed reads
* Gene counts

Analysis reports, tables and figures are stored in the `reports/` directory:

* Alignment metrics
* Gene expression tables and heatmap
* Raw and trimmed read counts and summary reports

---
## Example Pipeline Run
This repository provides an example of the pipeline using the Pseudomonas Aeruginosa genome and RNA-seq data from SRA.
Accessions:
- SRR14995084 
- SRR14995085 
- SRR14995086

To run the example, navigate to the pipeline root directory, then:

```commandline
bash PAO1_example/run_PAO1_pipeline.sh
```
---

The PAO1_example/PAO1 directory contains results and reports from a run using SRR14995084, SRR14995085 and SRR14995086.
## Notes

* All scripts are located in the `scripts/` directory.
* The pipeline assumes required tools are installed via the conda environment.

---

## Contributors

* Lucy Sanders
