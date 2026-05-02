#!/usr/bin/env bash

# Parameters:
#   $1 project name
#   $2 data directory path in relation to rna_seq_pipeline dir
#   $3 final path for project in relation to rna_seq_pipeline dir

# Source config variables and functions
source ./scripts/config.sh

# export PROJECT so variable is available for child scripts
export PROJECT="$1"
DATA_DIR="$2"
PROJECT_PATH="$3"
STEP_COUNT=6
STEP_HEADER="Pipeline Step"

# ----Start project pipeline----
mark_log_step_header "MICROBIAL RNA-SEQ PIPELINE"
bash scripts/trace.sh "Running microbial RNA-seq pipeline for $PROJECT"

# check for valid data
mark_log_step_header "VALIDATE DATA" "$STEP_HEADER 0/$STEP_COUNT"
bash scripts/data_checks.sh "$DATA_DIR" || exit 1

# setup new pipeline project
mark_log_step_header "SETUP PROJECT FILE STRUCTURE" "$STEP_HEADER 0/$STEP_COUNT"
bash scripts/new_pipeline_project.sh "$DATA_DIR"

# Run pre-trimming QC
mark_log_step_header "RAW READ QUALITY CONTROL" "$STEP_HEADER 1/$STEP_COUNT"
bash scripts/02_qc.sh "raw" || exit 1

# Trim reads
mark_log_step_header "RAW READ TRIMMING" "$STEP_HEADER 2/$STEP_COUNT"
 bash scripts/03_trimming.sh

# Run post-trimming QC
mark_log_step_header "TRIMMED READ QUALITY CONTROL" "$STEP_HEADER 3/$STEP_COUNT"
bash scripts/02_qc.sh "trimmed" || exit 1

# Perform alignment
mark_log_step_header "READ ALIGNMENT" "$STEP_HEADER 4/$STEP_COUNT"
 bash scripts/04_alignment.sh || exit 1

# Perform annotation
mark_log_step_header "ANNOTATION AND QUANTIFICATION" "$STEP_HEADER 5/$STEP_COUNT"
 bash scripts/05_annotation.sh || exit 1

# Perform visualization
mark_log_step_header "VISUALIZATION" "$STEP_HEADER 6/$STEP_COUNT"
bash scripts/06_visualization.sh || exit 1

# Move project to project directory
mv "$PROJECT" "$PROJECT_PATH"/