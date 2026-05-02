#!/usr/bin/env bash
# Parameters: PROJECT (optional, if not provided script uses env var value)

# Source config file
source scripts/config.sh

# Set variables
# get_param function sourced from config.sh
PROJECT=$(get_param "$1" "$PROJECT" "" "PROJECT")

# Set directory variables
RAW_DIR="$PROJECT"/data/raw
TRIMMED_DIR="$PROJECT"/data/trimmed
RESULTS_DIR="$PROJECT"/results/trimming

# For each *_1.fastq file in raw dir, find matching *_2.fastq and run fastp on pair
while IFS=$'\t' read -r SAMPLE R1 R2; do
    # Trim adapters, low-quality bases, and discard short reads (<30–50 bp).
    bash scripts/trace.sh "Trimming $SAMPLE reads"
    mark_log_header "FASTP"
    fastp \
      -i "$R1" \
      -I "$R2" \
      -o "$TRIMMED_DIR/${SAMPLE}_1.fastq" \
      -O "$TRIMMED_DIR/${SAMPLE}_2.fastq" \
      -h "$RESULTS_DIR/${SAMPLE}_fastp.html" \
      -j "$RESULTS_DIR/${SAMPLE/}_fastp.json"
done < <(bash scripts/paired_end_reads.sh "$RAW_DIR")



