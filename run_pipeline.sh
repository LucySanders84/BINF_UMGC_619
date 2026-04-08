#!/usr/bin/env bash

# Read SRAs from run_pipeline.sh arguments
SRAs=("$@")

# set directory variables
RAW_DIR="data/raw"
TRIMMED_DIR="data/trimmed"
ALIGN_DIR="data/aligned"
COUNT_DIR="results/counts"


# make directories
# add check for if directories exist
mkdir -p "$RAW_DIR" "$TRIMMED_DIR" "$ALIGN_DIR" "$COUNT_DIR"

for sra in "${SRAs[@]}"; do
    # start pipeline
    echo "Running microbial RNA-seq pipeline for $sra"

    # Obtain raw data in fastq format
    bash scripts/01_download_data.sh "$RAW_DIR" "$sra"

    # Run QC
    bash scripts/02_qc.sh

    # Trim reads
    bash scripts/03_trimming.sh

    # Perform alignment
    bash scripts/04_alignment.sh

    # Perform annotation
    bash scripts/05_annotation.sh

    # Perform visualization
    bash scripts/06_visualization.R
done