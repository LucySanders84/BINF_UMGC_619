#!/usr/bin/env bash

# Parameters: PROJECT (optional, if not provided script uses env var value)

# Source config file
source scripts/config.sh

# Set variables
# get_param function sourced from config.sh
PROJECT=$(get_param "$1" "$PROJECT" "" "PROJECT")
OUT_DIR="${PROJECT}/reports/alignment"
OUT_FILE="${OUT_DIR}/alignment_metrics.tsv"

# Header
printf "Sample\tTotal_Reads\tMapping_Percent\n" > "$OUT_FILE"
while IFS=$'\t' read -r LOG_FILE; do
    SAMPLE=$(basename "$LOG_FILE" "_hisat2.log")
    bash scripts/trace.sh "Extracting total reads and mapping percent from $SAMPLE alignment log"
    # Extract total reads
    TOTAL_READS=$(
        awk '/reads; of these:/{print $1; exit}' "$LOG_FILE"
    )

    # Extract mapping percent
    MAPPING_PERCENT=$(
        awk '/overall alignment rate/{print $1; exit}' "$LOG_FILE"
    )

    # Default values if parsing fails
    TOTAL_READS=${TOTAL_READS:-NA}
    MAPPING_PERCENT=${MAPPING_PERCENT:-NA}

    # Output to file
    bash scripts/trace.sh "Outputting alignment metrics to $OUT_FILE"
    printf "%s\t%s\t%s\n" "$SAMPLE" "$TOTAL_READS" "$MAPPING_PERCENT" >> "$OUT_FILE"
done < <(bash scripts/get_files.sh "$PROJECT"/logs/*.log)
