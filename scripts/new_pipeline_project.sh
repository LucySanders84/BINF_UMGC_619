#!/bin/bash

PROJECT="$1"
DATA_DIR="$2"

echo "$PROJECT $DATA_DIR"

# Create base directory
mkdir -p "$PROJECT"
cd "$PROJECT" || exit 1

# data directories
mkdir -p data/raw
mkdir -p data/trimmed
mkdir -p data/reference
mkdir -p data/aligned

# results directories
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

cd ../

# Enable nullglob so if no matches exist, it expands to nothing
shopt -s nullglob

cd "$DATA_DIR" || exit 1
ls

cd ../rna_seq_pipeline || exit 1

# move fastq files in DATA_DIR to data/raw
mv "$DATA_DIR"/*.fastq -t "$PROJECT"/data/raw/

# move reference genome gff, fasta/fna files in in DATA_DIR to data/reference
mv "$DATA_DIR"/*.{gff,fasta,fna} -t "$PROJECT"/data/reference/

# find genome index and if exists move to data/reference
mv "$DATA_DIR"/*genome_index* -t "$PROJECT"/data/reference/

# Disable nullglob
shopt -u nullglob

echo "$PROJECT rna_seq_pipeline project created successfully."

echo "Current working directory"
pwd
