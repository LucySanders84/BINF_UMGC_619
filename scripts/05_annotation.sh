#!/usr/bin/env bash

# Parameters:
PROJECT="$1"
# Prepare GFF
# Set nullglob so the loop won't run if no files match
shopt -s nullglob

GFF=("$PROJECT"/data/reference/*.gff)


# Map alignments to gene features
while IFS=$'\t' read -r BAM; do
    SAMPLE=$(basename "$BAM" .bam)
    bash scripts/trace.sh "FeatureCounts is quantifying gene expression for $SAMPLE"
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


