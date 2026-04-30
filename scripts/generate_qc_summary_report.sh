#!/usr/bin/env bash

# Parameters: QC dir, PROJECT (optional, if not provided script uses env var value)

# Source config file
source scripts/config.sh

# Set variables
QC_DIR="$1"
# get_param function sourced from config.sh
PROJECT=$(get_param "$2" "$PROJECT" "" "PROJECT")
RESULTS_DIR="$PROJECT/results/qc/$QC_DIR"
DATA_TXTS="$RESULTS_DIR/fastqc_data"

# set reports directory variable
if [[ "$QC_DIR" == 'raw' ]]; then
    REPORTS_DIR="$PROJECT/reports/quality_control"
else
    REPORTS_DIR="$PROJECT/reports/read_cleaning"
fi

# --- Summarize read quality, GC content, adapter contamination, duplication.

mkdir -p "$DATA_TXTS"

shopt -s nullglob

for zip in "$RESULTS_DIR"/*_fastqc.zip; do
    # extract sample name (SRR123_1 etc.)
    sample=$(basename "$zip" _fastqc.zip)

    bash scripts/trace.sh "Processing $sample zipped qc file"

    # extract fastqc_data.txt directly
    unzip -p "$zip" "*/fastqc_data.txt" > "$DATA_TXTS/${sample}_fastqc_data.txt"
done

touch summary.tmp
echo "Sample"$'\t'"Read Count"$'\t'"Median Quality"$'\t'"% >= Q20"$'\t'"% >= Q30"$'\t'"$ GC Content"$'\t'"% Adapter Content"$'\t'"Adapter"$'\t'"Adapter Content"$'\t'"% Deduplication"$'\t'"% Duplication" > summary.tmp

get_max() {
    local -a values=("$@")
    printf "%s\n" "${values[@]}" | awk '
        NR == 1 { max=$1 }
        $1 > max { max=$1 }
        END { print max }'
}

while IFS=$'\t' read -r SAMPLE R1 R2; do
    bash scripts/trace.sh "Gathering report data for $SAMPLE"
    read_count=$(grep -Po '(?<=^Total Sequences[[:blank:]])\d*' < "$R1")

    median_qualities=()
    base_Q30s=()
    base_Q20s=()
    gcs=()
    adapter_maxs=()
    adapter_sources=()
    deduplications=()
    reports=("$R1" "$R2")
    # Read quality


    for report in "${reports[@]}"; do
        # median quality score per base
        median=$(awk 'BEGIN{sum=0; count=0}
            /^>>Per base sequence quality/ {flag=1; next}
            /^>>END_MODULE/ {flag=0}
            flag && $1 ~ /^[0-9]+$/ {sum+=$3; count++}
            END {print sum/count}' "$report")
        median_qualities+=("$median")

        # Q20 and Q30 scores
        IFS=',' read -ra q_scores <<< "$(awk 'BEGIN{q20=0; q30=0; count=0}
            /^>>Per base sequence quality/ {flag=1; next}
            /^>>END_MODULE/ {flag=0}
            flag && $1 ~ /^[0-9]+$/ {if($3 >= 20) q20++; if($3 >= 30) q30++; count++ }
            END { printf "%s,%s", (q20 / count)*100, (q30 / count)*100 }' "$report")"
        base_Q20s+=("${q_scores[0]}")
        base_Q30s+=("${q_scores[1]}")

        # GC content %
        gcs+=("$(grep -Po '(?<=^%GC\t)\d{2}' < "$report")")

        # Adapter content
        max_source=(0 "")

        # read adapter content to .tmp file
        awk -F'\t' -v OFS='\t' '
        /^>>Adapter Content/ {flag=1; next}
        /^>>END_MODULE/ {flag=0}
        flag {print $2, $3, $4, $5, $6, $7}' "$report" > adapter_content.tmp

        #   max adapter %
        for i in {1..6}; do
            cut -f"$i" adapter_content.tmp > adapter.tmp
            IFS=',' read -ra max_source <<< "$(awk -v awk_max_source_str="${max_source[*]}" '
            BEGIN {
                split(awk_max_source_str, awk_max_source, " ");
                getline; current_source = $0
            }
            {if ($0 + 0 > awk_max_source[1]) { awk_max_source[1] = $0 + 0; awk_max_source[2] = current_source}}
            END { printf "%s,%s", awk_max_source[1], awk_max_source[2] }
            ' adapter.tmp)"
        done

        adapter_maxs+=("${max_source[0]}")
        adapter_sources+=("${max_source[1]}")

        rm adapter.tmp adapter_content.tmp

        # Duplication
        #   Total Deduplicated %
        deduplications+=("$(grep -Po '(?<=^#Total Deduplicated Percentage\t)\d+' < "$report")")
    done

    median_quality=$(get_max "${median_qualities[@]}")
    base_Q30=$(get_max "${base_Q30s[@]}")
    base_Q20=$(get_max "${base_Q20s[@]}")
    gc=$(get_max "${gcs[@]}")
    deduplication=$(get_max "${deduplications[@]}")

    read -r adapter_max max_idx < <(printf "%s\n" "${adapter_maxs[@]}" | awk '
        NR == 1 { max=$1; idx=0 }
        $1 > max { max=$1; idx=NR-1 }
        END { print max, idx }')
    adapter_source="${adapter_sources[max_idx]}"

    #   classification (low = < 5%; mod = 5-20%; high = > 20%)
    adapter_classif="$(awk -v max="$adapter_max" 'BEGIN {
        if (max * 100 < 5) print "low"
        else if (max * 100 < 20) print "moderate"
        else print "high"}')"

    #   Duplication %
    duplication=$((100 - deduplication))

    row="$SAMPLE"$'\t'"$read_count"$'\t'"$median_quality"$'\t'"$base_Q20"$'\t'"$base_Q30"$'\t'"$gc"$'\t'"$adapter_max"$'\t'"$adapter_source"$'\t'"$adapter_classif"$'\t'"$deduplication"$'\t'"$duplication"
    echo "$row" >> summary.tmp

done < <(bash scripts/paired_fastqcs.sh "$DATA_TXTS")

bash scripts/trace.sh "Writing summary report for $QC_DIR reads"
mv summary.tmp "$REPORTS_DIR/read_summary_report.tsv"







