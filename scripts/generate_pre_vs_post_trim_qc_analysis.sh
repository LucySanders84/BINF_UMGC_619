#!/usr/bin/env bash

results_dir="$1"
samples=("${@:2}")
# Compare pre- and post-trimming statistics.
# multiqc -d "$results_dir/" -o "$results_dir/multiqc/"


# Deliverables (within Group File):
# 1 plot comparing pre/post QC.
  # generate plot for value most changed by cleaning
# 1 table showing raw vs. cleaned read counts.


  # setup raw vs cleaned read count table file
data_file="$results_dir"/read_counts.tsv
touch "$data_file"
echo "Sample"$'\t'"Raw Reads"$'\t'"Clean Reads" >> "$data_file"

  # for each sample:
    # find read count for pre
    # find read count for post
for sample in "${samples[@]}"; do
    raw_reads="$(grep -Po '(?<=^Total Sequences\t)\d+' < "$results_dir/raw/${sample}_2_fastqc/fastqc_data.txt")"
    trimmed_reads="$(grep -Po '(?<=^Total Sequences\t)\d+' < "$results_dir/trimmed/${sample}_2_fastqc/fastqc_data.txt")"
    echo "$sample"$'\t'"$raw_reads"$'\t'"$trimmed_reads" >> "$data_file"
done

awk '{print $0}' < "$data_file"