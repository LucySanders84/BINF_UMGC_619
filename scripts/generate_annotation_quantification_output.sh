#!/usr/bin/env bash

# Parameters: PROJECT (optional, if not provided script uses env var value)

# Source config file
source scripts/config.sh

# Set variables
# get_param function sourced from config.sh
PROJECT=$(get_param "$1" "$PROJECT" "" "PROJECT")

# Annotation and Quantification
#   Table of top 10 expressed genes
bash scripts/top_genes.sh
#   Heatmap of top 10 expressed genes
python scripts/plot_heatmap.py "$PROJECT"