#!/bin/bash

# Parameters: data directory PROJECT (optional, if not provided script uses env var value)

# Source config file
source scripts/config.sh

# Set variables
DATA_DIR="$1"
# get_param function sourced from config.sh
PROJECT=$(get_param "$2" "$PROJECT" "" "PROJECT")

bash scripts/trace.sh "Setting up $PROJECT pipeline project"

# Project directory
bash scripts/trace.sh "Validating projects directory"
mkdir -p projects

# Create base directory
bash scripts/trace.sh "Creating $PROJECT directory"
mkdir -p "$PROJECT"

# Open project directory
cd "$PROJECT" || exit 1

# data directories
mkdir -p data
mkdir -p data/raw
mkdir -p data/trimmed
mkdir -p data/reference
mkdir -p data/aligned

# results directories
mkdir -p results
mkdir -p results/qc
mkdir -p results/qc/raw
mkdir -p results/qc/trimmed
mkdir -p results/trimming
mkdir -p results/counts

# logs
mkdir -p logs

# reports
mkdir -p reports
mkdir -p reports/quality_control
mkdir -p reports/read_cleaning
mkdir -p reports/alignment
mkdir -p reports/annotation_quantification


# Navigate back to rna_seq_pipeline
cd ../

# Enable nullglob so if no matches exist, it expands to nothing
shopt -s nullglob

# transfer data to working directory
bash scripts/trace.sh "Moving data from $DATA_DIR to $PROJECT/data"

# move fastq files in DATA_DIR to data/raw
mv "$DATA_DIR"/*.fastq -t "$PROJECT"/data/raw
# move reference genome gff, fasta/fna files in in DATA_DIR to data/reference
mv "$DATA_DIR"/*.{gff,fasta,fna} -t "$PROJECT"/data/reference
# find genome index and if exists move to data/reference
mv "$DATA_DIR"/*genome_index* -t "$PROJECT"/data/reference

# Disable nullglob
shopt -u nullglob

bash scripts/trace.sh "$PROJECT RNA Seq pipeline project created successfully. Continuing..."