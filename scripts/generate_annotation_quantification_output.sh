#!/usr/bin/env bash

# Parameters:
PROJECT="$1"

# Annotation and Quantification
#   Table of top 10 expressed genes
bash scripts/top_genes.sh "$PROJECT"
#   Heatmap of top 10 expressed genes
python scripts/plot_heatmap.py "$PROJECT"