#!/usr/bin/env bash

SAMPLES=("${@}")

INPUT_DIR="results/counts"
ALL_GENES="$INPUT_DIR/expressed_gene_counts.tsv"
TOP_10_GENES="$INPUT_DIR/top_10_genes.tsv"
HEADERS=("GeneID" "${SAMPLES[@]}" "Mean Count")

#setup output file
IFS=$'\t'
printf "%s\n" "$(IFS=$'\t'; echo "${HEADERS[*]}")" > "$TOP_10_GENES"
printf "%s\n" "$(IFS=$'\t'; echo "${HEADERS[*]}")" > "$ALL_GENES"

# Initialize temporary file with the first count file's gene id column
counts=("$INPUT_DIR"/*.txt)
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
cat next.tmp >> "$ALL_GENES"
head -n 10 next.tmp >> "$TOP_10_GENES"

rm ./*.tmp