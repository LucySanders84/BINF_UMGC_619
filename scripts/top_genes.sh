#!/usr/bin/env bash

# Parameters: PROJECT (optional, if not provided script uses env var value)

# Source config file
source scripts/config.sh

# Set variables
# get_param function sourced from config.sh
PROJECT=$(get_param "$1" "$PROJECT" "" "PROJECT")
SAMPLES=()

INPUT_DIR="${PROJECT}/results/counts"
REPORT_DIR="${PROJECT}/reports/annotation_quantification"
ALL_GENES="${REPORT_DIR}/expressed_gene_counts.tsv"
TOP_10_GENES="${REPORT_DIR}/top_10_genes.tsv"


# Initialize temporary file with the first count file's gene id column
counts=("$INPUT_DIR"/*.txt)

# Get sample ids from count.txt filenames
for f in "${counts[@]}"; do
  SAMPLES+=("$(basename "$f" _counts.txt)")
done

# Add geneID column from counts[0] to tmp file
tail -n +3 "${counts[0]}" | cut -f1 > combined.tmp

# Loop through the count files and append their count columns
for f in "${counts[@]}"; do
    paste -d $'\t' combined.tmp <(tail -n +3 "$f" | cut -f7) > next.tmp && mv next.tmp combined.tmp
done

paste -d $'\t' combined.tmp <(awk '{
    delete arr;
    for (i=2; i<=NF; i++) arr[i-1]=$i;
    sum = 0
    for (i=1; i<=length(arr); i++) sum+=arr[i];
    print int(sum/length(arr))
}' < combined.tmp) > next.tmp

sort_col=$((${#SAMPLES[@]} + 2))
sort -t$'\t' -n -r -k"${sort_col},${sort_col}" next.tmp -o next.tmp

# Final output files
HEADERS=("GeneID" "${SAMPLES[@]}" "Mean Count")

#setup output file
printf "%s\n" "$(IFS=$'\t'; echo "${HEADERS[*]}")" > "$TOP_10_GENES"
printf "%s\n" "$(IFS=$'\t'; echo "${HEADERS[*]}")" > "$ALL_GENES"

cat next.tmp >> "$ALL_GENES"
head -n 10 next.tmp >> "$TOP_10_GENES"

rm ./*.tmp