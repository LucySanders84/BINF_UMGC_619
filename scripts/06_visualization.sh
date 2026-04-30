#!/usr/bin/env bash

# Parameters: PROJECT (optional, if not provided script uses env var value)

# Source config file
source scripts/config.sh

# Set variables
# get_param function sourced from config.sh
PROJECT=$(get_param "$1" "$PROJECT" "" "PROJECT")

## Quality Control
##   1–2 QC plots
bash scripts/generate_quality_control_output.sh "$PROJECT"
#
## Read Cleaning
##   1 plot comparing pre/post QC.
##   1 table showing raw vs. cleaned read counts.
bash scripts/generate_read_cleaning_output.sh "$PROJECT"
#
## Alignment
##   1-2 plots or tables of alignment metrics (total reads, mapping %)
bash scripts/generate_alignment_output.sh "$PROJECT"
#
## Annotation and Quantification
##   Table of top 10 expressed genes
##   Heatmap of top 10 expressed genes
bash scripts/generate_annotation_quantification_output.sh "$PROJECT"
#