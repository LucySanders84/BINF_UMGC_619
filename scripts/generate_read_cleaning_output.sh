#!/usr/bin/env bash

# Parameters: PROJECT (optional, if not provided script uses env var value)

# Source config file
source scripts/config.sh

# Set variables
# get_param function sourced from config.sh
PROJECT=$(get_param "$1" "$PROJECT" "" "PROJECT")

FASTQC_DIR="$PROJECT/results/qc"
REPORTS_DIR="$PROJECT/reports/read_cleaning"
# Read Cleaning
#   1 plot comparing pre/post QC.

while IFS=$'\t' read -r SAMPLE R1 R2; do
    TRIMMED_R1="$FASTQC_DIR/trimmed/trimmed_$SAMPLE"_1_fastqc.zip
    mv "$FASTQC_DIR/trimmed/$SAMPLE"_1_fastqc.zip "$TRIMMED_R1"
    # for each sample create multiQC with paired fastQC dirs
    multiqc -d "$R1" "$TRIMMED_R1" -o "$REPORTS_DIR/$SAMPLE/" -n "$SAMPLE"_qc_report.html
    mv  "$TRIMMED_R1" "$FASTQC_DIR/trimmed/$SAMPLE"_1_fastqc.zip
done < <(bash scripts/paired_fastqcs.sh "$FASTQC_DIR/raw")

#   1 table showing raw vs. cleaned read counts.

# create summary report for trimmed reads
bash scripts/generate_qc_summary_report.sh "trimmed"

# create tmp file
touch read_counts.tmp
echo "Sample"$'\t'"Raw Reads"$'\t'"Clean Reads" >> read_counts.tmp

  # for each sample:
    # find read count for pre
    # find read count for post
while IFS=$'\t' read -r SAMPLE R1 R2; do
    declare -A COUNTS
    TYPES=("raw" "trimmed")

    for TYPE in "${TYPES[@]}"; do
        COUNTS["$TYPE"]=$(grep -Po '(?<=^Total Sequences\t)\d+' < "$FASTQC_DIR/$TYPE/fastqc_data/${SAMPLE}_1_fastqc_data.txt")
    done

    echo "$SAMPLE"$'\t'"${COUNTS["raw"]}"$'\t'"${COUNTS["trimmed"]}" >> read_counts.tmp
done < <(bash scripts/paired_fastqcs.sh "$FASTQC_DIR/raw")


DATA_FILE="$REPORTS_DIR"/read_counts.tsv
touch "$DATA_FILE"
mv read_counts.tmp "$DATA_FILE"