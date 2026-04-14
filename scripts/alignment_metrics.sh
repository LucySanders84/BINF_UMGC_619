#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash scripts/alignment_metrics.sh SRR14995081 SRR14995082 SRR14995083
#
# Expects log files at:
#   logs/{sample}_hisat2.log
#
# Writes:
#   results/alignment_metrics.tsv

SAMPLES=("${@}")

LOG_DIR="logs"
OUT_DIR="results/alignment"
OUT_FILE="${OUT_DIR}/alignment_metrics.tsv"

mkdir -p "$OUT_DIR"

# Header
printf "Sample\tTotal_Reads\tMapping_Percent\n" > "$OUT_FILE"

for SAMPLE in "${SAMPLES[@]}"; do
    LOG_FILE="${LOG_DIR}/${SAMPLE}_hisat2.log"

    if [ ! -f "$LOG_FILE" ]; then
        echo "Warning: log file not found for ${SAMPLE}: ${LOG_FILE}" >&2
        printf "%s\tNA\tNA\n" "$SAMPLE" >> "$OUT_FILE"
        continue
    fi

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
done

echo "Alignment metrics table written to: $OUT_FILE"