#!/usr/bin/env bash

# Parameters: PROJECT (optional, if not provided script uses env var value)

# Source config file
source scripts/config.sh

# Set variables
# get_param function sourced from config.sh
PROJECT=$(get_param "$1" "$PROJECT" "" "PROJECT")
REPORTS_DIR="$PROJECT"/reports/quality_control
REPORT_FILE="$REPORTS_DIR"/read_counts_duplicates.tsv

# make tmp file
touch qc_counts.tmp

row="Sample"$'\t'"Read Count"$'\t'"Duplicate Count"
echo "$row" > qc_counts.tmp

# read summary_report.tsv
tail -n +2 "$REPORTS_DIR/read_summary_report.tsv" | awk ' BEGIN {OFS="\t"} {
    # for each line print sample, raw read count, duplication count
    dupes=($2+0) * ($11/100)
    print $1, $2, dupes
}' >> qc_counts.tmp

# write to report file
touch "$REPORT_FILE"
mv qc_counts.tmp "$REPORT_FILE"
