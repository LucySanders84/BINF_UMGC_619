#!/usr/bin/env bash

DATA_DIR="test_data"
PROJECT_PATH="projects"
PROJECT="PAO1"

FNA=GCF_000006765.1_ASM676v1/GCF_000006765.1_ASM676v1_genomic.fna.gz
GFF=GCF_000006765.1_ASM676v1/GCF_000006765.1_ASM676v1_genomic.gff.gz
FTP_PATH="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/006/765"
## Download RNA Seq data for PAO1 species
bash scripts/01_download_data.sh "$DATA_DIR" SRR14995084 SRR14995085 SRR14995086

# Download reference genome and GFF

if [ -z "$(ls "$DATA_DIR"/*.fna "$DATA_DIR"/*.fna.gz  2> /dev/null)" ]; then
  wget -P "$DATA_DIR" "$FTP_PATH/$FNA"
fi

if [ -z "$(ls "$DATA_DIR"/*.gff "$DATA_DIR"/*.gff.gz  2> /dev/null)" ]; then
  wget -P "$DATA_DIR" "$FTP_PATH/$GFF"
fi

if [ "$(ls "$DATA_DIR"/*.gz  2> /dev/null)" ]; then
    gunzip "$DATA_DIR"/*.gz
fi
# Run pipeline
bash scripts/run_pipeline.sh "$PROJECT" "$DATA_DIR" "$PROJECT_PATH"

