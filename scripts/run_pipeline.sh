#!/usr/bin/env bash

# Parameters:
#   $1 project name
#   $2 data directory path in relation to rna_seq_pipeline dir
#   $3 final path for project in relation to rna_seq_pipeline dir

PROJECT="$1"
DATA_DIR="$2"
PROJECT_PATH="$3"

# setup new pipeline project
bash scripts/trace.sh "Setting up $PROJECT pipeline project"
bash scripts/new_pipeline_project.sh "$PROJECT" "$DATA_DIR"

# ----Start project pipeline----

bash scripts/trace.sh "Running microbial RNA-seq pipeline for $PROJECT"

# Run pre-trimming QC
bash scripts/02_qc.sh "$PROJECT" raw

# Trim reads
bash scripts/03_trimming.sh "$PROJECT"

# Run post-trimming QC
bash scripts/trace.sh "Running post-trim QC analysis"
bash scripts/02_qc.sh "$PROJECT" trimmed

# Perform alignment
bash scripts/04_alignment.sh "$PROJECT"

# Perform annotation
bash scripts/05_annotation.sh "$PROJECT"

# ----Generate plots and tables----

# Quality Control
#   1–2 QC plots
bash scripts/generate_quality_control_output.sh "$PROJECT"

# Read Cleaning
#   1 plot comparing pre/post QC.
#   1 table showing raw vs. cleaned read counts.
bash scripts/generate_read_cleaning_output.sh "$PROJECT"

# Alignment
#   1-2 plots or tables of alignment metrics (total reads, mapping %)
bash scripts/generate_alignment_output.sh "$PROJECT"

# Annotation and Quantification
#   Table of top 10 expressed genes
#   Heatmap of top 10 expressed genes
bash scripts/generate_annotation_quantification_output.sh "$PROJECT"

# Move project to project directory
mv "$PROJECT" -t "$PROJECT_PATH"