#!/usr/bin/env bash

# Read SRAs from run_pipeline.sh arguments
SRAs=("$@")

# set directory variables
RAW_DIR="data/raw"
TRIMMED_DIR="data/trimmed"
TRIMMED_RESULTS_DIR="results/trimming"
QC_RESULTS_DIR="results/qc"
ALIGN_DIR="data/aligned"
COUNT_DIR="results/counts"


# make directories
# add check for if directories exist
# mkdir -p "$RAW_DIR" "$TRIMMED_DIR" "$ALIGN_DIR" "$COUNT_DIR"

# start pipeline
# bash scripts/trace.sh "Running microbial RNA-seq pipeline for ${SRAs[*]}"

# Obtain raw data in fastq format
# bash scripts/01_download_data.sh "$RAW_DIR" "${SRAs[@]}"

# Run pre-trimming QC
# bash scripts/02_qc.sh "$RAW_DIR" "$QC_RESULTS_DIR/raw" "${SRAs[@]}"

# Trim reads
# bash scripts/03_trimming.sh "$RAW_DIR" "$TRIMMED_DIR" "$TRIMMED_RESULTS_DIR" "${SRAs[@]}"

# Run post-trimming QC
# bash scripts/trace.sh "Running post-trim QC analysis"
# bash scripts/02_qc.sh "$TRIMMED_DIR" "$QC_RESULTS_DIR/trimmed" "${SRAs[@]}"

# Compile pre vs post-trimming QC statistics
bash scripts/generate_pre_vs_post_trim_qc_analysis.sh results/qc "${SRAs[@]}"
# Perform alignment
bash scripts/04_alignment.sh

# Perform annotation
bash scripts/05_annotation.sh

# Perform visualization
bash scripts/06_visualization.R
