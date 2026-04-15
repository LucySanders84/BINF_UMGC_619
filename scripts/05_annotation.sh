#!/usr/bin/env bash

REFERENCE_DIR="$1"
SAMPLES=("${@:2}")
# Prepare GFF
# Set nullglob so the loop won't run if no files match
shopt -s nullglob
ZIPPED_GFF=("$REFERENCE_DIR"/*.gff.gz)

echo "${ZIPPED_GFF[*]}"
for GFF in "${ZIPPED_GFF[@]}"; do
    gunzip "$GFF" > "${GFF%.*}"
done

GFF=("$REFERENCE_DIR"/*.gff)

for SAMPLE in "${SAMPLES[@]}"; do
    # Run feature counts
    featureCounts \
      -T 8 \
      -p --countReadPairs \
      -s 0 \
      -a "${GFF[0]}" \
      -o results/counts/"$SAMPLE"_counts.txt \
      -t gene \
      -g Alias \
      data/aligned/"$SAMPLE".bam
done
# Compile top 10 expressed genes table
bash scripts/top_genes.sh "${SAMPLES[@]}"

