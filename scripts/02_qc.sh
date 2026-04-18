#!/usr/bin/env bash
# Parameters:
    # $1 project name
    # $2 fastq type (raw or trimmed)

PROJECT="$1"
FASTQ_TYPE="$2"

bash scripts/trace.sh "Performing fastQC analysis on the following $FASTQ_TYPE paired-end read fastq files"

# Perform fastQC analysis
fastqc "$PROJECT"/data/"$FASTQ_TYPE"/*.fastq -o "$PROJECT"/results/qc/"$FASTQ_TYPE"/ -t 8







