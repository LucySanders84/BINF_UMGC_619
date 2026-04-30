#!/usr/bin/env bash

# Parameters:
#   $1 project name
#   $2 data directory path in relation to rna_seq_pipeline dir
#   $3 final path for project in relation to rna_seq_pipeline dir

# export PROJECT so variable is available for child scripts
export PROJECT="$1"
DATA_DIR="$2"
PROJECT_PATH="$3"

# check for valid data
bash scripts/data_checks.sh "$DATA_DIR" || exit 1


# setup new pipeline project
bash scripts/new_pipeline_project.sh "$DATA_DIR"

# ----Start project pipeline----
bash scripts/trace.sh "Running microbial RNA-seq pipeline for $PROJECT"

# Run pre-trimming QC
bash scripts/trace.sh "Running QC analysis on raw FASTQ files"
bash scripts/02_qc.sh "raw" || exit 1

# Trim reads
 bash scripts/03_trimming.sh

# Run post-trimming QC
bash scripts/trace.sh "Running QC analysis on trimmed FASTQ files"
bash scripts/02_qc.sh "trimmed" || exit 1

# Perform alignment
 bash scripts/04_alignment.sh || exit 1

# Perform annotation
 bash scripts/05_annotation.sh || exit 1

# Perform visualization
bash scripts/06_visualization.sh || exit 1

# Move project to project directory
mv "$PROJECT" "$PROJECT_PATH"/