#!/bin/bash

PROJECT="rna_seq_pipeline"

# Create base directory
mkdir -p "$PROJECT"
cd "$PROJECT" || exit

# Top-level files
touch README.md

# environment
mkdir -p environment
touch environment/environment.yml

# data directories
mkdir -p data/raw
mkdir -p data/trimmed
mkdir -p data/reference

# results directories
mkdir -p results/qc
mkdir -p results/trimming
mkdir -p results/alignment
mkdir -p results/counts
mkdir -p results/plots

# scripts + files
mkdir -p scripts
touch scripts/01_download_data.sh
touch scripts/02_qc.sh
touch scripts/03_trimming.sh
touch scripts/04_alignment.sh
touch scripts/05_quantification.sh
touch scripts/06_visualization.R

# notebooks
mkdir -p notebooks
touch notebooks/analysis.ipynb

# docs
mkdir -p docs/figures

# logs
mkdir -p logs

echo "rna_seq_pipeline structure created successfully."