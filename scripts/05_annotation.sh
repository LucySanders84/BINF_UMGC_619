#!/usr/bin/env bash

# Parameters:
PROJECT="$1"
# Prepare GFF
# Set nullglob so the loop won't run if no files match
shopt -s nullglob

GFF=$(bash scripts/get_files.sh \
  "$PROJECT"/data/reference/*.gff \
  "$PROJECT"/data/reference/*.gff.gz)

# if GFF file is a .gz then gunzip
if [[ "$GFF" == *.gz ]]; then
    gunzip "$GFF" > "${GFF%.*}"
fi

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
      -g Alias \
      "$BAM"
done < <(bash scripts/get_files.sh \
  "$PROJECT"/data/aligned/*.bam)


