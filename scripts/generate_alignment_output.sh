#!/usr/bin/env bash

# Parameters:
PROJECT="$1"

# Usage:
#   bash scripts/alignment_metrics.sh {project_name}
#
# Expects log files at:
#   logs/{sample}_hisat2.log
#
# Writes:
#   {project}/reports/alignment/alignment_metrics.tsv


OUT_DIR="${PROJECT}/reports/alignment"
OUT_FILE="${OUT_DIR}/alignment_metrics.tsv"

# Header
printf "Sample\tTotal_Reads\tMapping_Percent\n" > "$OUT_FILE"

while IFS=$'\t' read -r LOG_FILE; do
    SAMPLE=$(basename "$LOG_FILE" "_hisat2.log")
    # Extract total reads from line like:
    # 1234567 reads; of these:
    TOTAL_READS=$(
        awk '/reads; of these:/{print $1; exit}' "$LOG_FILE"
    )

    # Extract mapping percent from line like:
    # 95.00% overall alignment rate
    MAPPING_PERCENT=$(
        awk '/overall alignment rate/{print $1; exit}' "$LOG_FILE"
    )

    # Fallbacks if parsing fails
    TOTAL_READS=${TOTAL_READS:-NA}
    MAPPING_PERCENT=${MAPPING_PERCENT:-NA}

    printf "%s\t%s\t%s\n" "$SAMPLE" "$TOTAL_READS" "$MAPPING_PERCENT" >> "$OUT_FILE"
done < <(bash scripts/get_files.sh "$PROJECT"/logs/*.log)



echo "Alignment metrics table written to: $OUT_FILE"