#!/usr/bin/env bash

data_dir="$1"
results_dir="$2"

bash scripts/trace.sh "Starting fastQC analysis"

ls "$data_dir"/*.fastq

# Perform fastQC analysis
fastqc "$data_dir"/*.fastq -o "$results_dir" -t 8

