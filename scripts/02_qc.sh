#!/usr/bin/env bash
# Parameters: fastq type (raw or trimmed), PROJECT (optional, if not provided script uses env var value)

# Source config file
source scripts/config.sh

# Set variables
FASTQ_TYPE="$1"
# get_param function sourced from config.sh
PROJECT=$(get_param "$2" "$PROJECT" "" "PROJECT")

bash scripts/trace.sh "Performing fastQC analysis on $FASTQ_TYPE paired-end read fastq files"

# Perform fastQC analysis
fastqc "$PROJECT"/data/"$FASTQ_TYPE"/*.fastq -o "$PROJECT"/results/qc/"$FASTQ_TYPE"/ -t 8







