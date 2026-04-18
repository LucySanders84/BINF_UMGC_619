#!/usr/bin/env bash

DATA_DIR="test_data"
PROJECT_PATH="projects"
PROJECT="PAO1"

# Download RNA Seq data for PAO1 species
bash scripts/01_download_data.sh "$DATA_DIR" SRR14995084 SRR14995085 SRR14995086

# Download reference genome and GFF
wget -P "$DATA_DIR" https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/006/765/GCF_000006765.1_ASM676v1/GCF_000006765.1_ASM676v1_genomic.fna.gz
wget -P "$DATA_DIR" https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/006/765/GCF_000006765.1_ASM676v1/GCF_000006765.1_ASM676v1_genomic.gff.gz

# Run pipeline
bash scripts/run_pipeline.sh "$PROJECT" "$DATA_DIR" "$PROJECT_PATH"

# Enable nullglob so if no matches exist, it expands to nothing
shopt -s nullglob

