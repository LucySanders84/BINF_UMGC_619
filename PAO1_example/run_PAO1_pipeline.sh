#!/usr/bin/env bash
shopt -s nullglob
# This script runs scripts/run_pipeline.sh for PAO1 samples
# SRR14995084 SRR14995085 SRR14995086.

# PROJECT, PROJECT_PATH, DATA_DIR sourced from config.sh
source "$(dirname -- "${BASH_SOURCE[0]}")/config.sh"

# set local variables
PROJECT_DIR="${PROJECT_PATH}/$PROJECT"

# create PROJECT_PATH
mkdir -p "$PROJECT_PATH"

# check if project already exists
if [ -d "$PROJECT_DIR" ]; then
  bash scripts/trace.sh "$PROJECT_DIR already exists. Exiting pipeline"; exit 1
fi

# ACTIVATE CONDA ENV
# set conda env name from environment.yml
ENV_NAME=$(sed -n 's/^name: //p' environment.yml)

# initiate conda in shell
eval "$(conda shell.bash hook)"

# create & activate env or activate & update env to match environment.yml
CONDA_ENVS=$(conda env list)
for env in "${CONDA_ENVS[@]}"; do
    if [[ "$env" == "$ENV_NAME" ]]; then
        conda activate "$ENV_NAME"
        break
    else
        conda env create -f environment.yml
        conda activate "$ENV_NAME"
    fi
done

# Download RNA Seq data for PAO1 species
bash scripts/01_download_data.sh "$DATA_DIR" "$SAMPLE_SRA_IDS"

# DOWNLOAD REFERENCE GENOME AND ANNOTATION FILES
bash scripts/trace.sh "Setting up reference genome files"
# Search for reference files in DATA_DIR
GENOME=("$DATA_DIR"/*.fna "$DATA_DIR"/*.fna.gz)
GFF_FILE=("$DATA_DIR"/*.gff "$DATA_DIR"/*.gff.gz)
# If not found, download urls set in config.sh environment variables
if [ ${#GENOME[@]} -eq 0 ]; then
  wget -P "$DATA_DIR" "$FNA_URL"
fi

if [ ${#GFF_FILE[@]} -eq 0 ]; then
  wget -P "$DATA_DIR" "$GFF_URL"
fi
# If files are zipped, unzipped
ZIPPED=("$DATA_DIR"/*.gz)
if [ ${#ZIPPED[@]} -gt 0 ]; then
    gunzip "$DATA_DIR"/*.gz
fi

# RUN PIPELINE
bash scripts/run_pipeline.sh "$PROJECT" "$DATA_DIR" "$PROJECT_PATH" || exit 1

