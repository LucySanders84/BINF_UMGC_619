#!/usr/bin/env bash

# Parameters: PROJECT (optional, if not provided script uses env var value)

# Source config file
source scripts/config.sh

# Set variables
# get_param function sourced from config.sh
PROJECT=$(get_param "$1" "$PROJECT" "" "PROJECT")

FASTQC_DIR="$PROJECT/results/qc/raw"
REPORTS_DIR="$PROJECT/reports/quality_control"
# Quality Control
#  1–2 QC plots

while IFS=$'\t' read -r SAMPLE R1 R2; do
    # for each sample create multiQC with paired fastQC dirs
    multiqc "$R1" "$R2" -o "$REPORTS_DIR/$SAMPLE/" -n "$SAMPLE"_qc_report.html
done < <(bash scripts/paired_fastqcs.sh "$FASTQC_DIR")


#  1 table of raw read counts and duplicates
bash scripts/generate_qc_summary_report.sh "raw"
bash scripts/raw_read_counts_duplicates.sh