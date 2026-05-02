#!/usr/bin/env bash

# Parameters: PROJECT (optional, if not provided script uses env var value)

# Source config file
source scripts/config.sh

# Set variables
# get_param function sourced from config.sh
PROJECT=$(get_param "$1" "$PROJECT" "" "PROJECT")

# Prepare annotation file
# Set nullglob so the loop won't run if no files match
shopt -s nullglob
GFF=("$PROJECT"/data/reference/*.gff)

# Map alignments to gene features
while IFS=$'\t' read -r BAM; do
    SAMPLE=$(basename "$BAM" .bam)
    bash scripts/trace.sh "Quantifying gene expression for $SAMPLE"
    mark_log_header "FEATURECOUNTS"
    # Run feature counts
    featureCounts \
      -T 8 \
      -p --countReadPairs \
      -s 0 \
      -a "$GFF" \
      -o "$PROJECT/results/counts/$SAMPLE"_counts.txt \
      -t gene \
      -g ID \
      "$BAM"
done < <(bash scripts/get_files.sh \
  "$PROJECT"/data/aligned/*.bam)


