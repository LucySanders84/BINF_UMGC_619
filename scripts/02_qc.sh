#!/usr/bin/env bash
# Parameters: (data_dir, results_dir, sample ids)
data_dir="$1"
results_dir="$2"
samples=("${@:3}")

summary_report="$results_dir/summary_report.tsv"
# reset summary_report.tsv
if [[ -f "$summary_report" ]]; then
    rm "$results_dir/summary_report.tsv"
fi





# Tasks
# For each sample
    # Generate per-sample QC reports (fastQC).
    bash scripts/trace.sh "Performing fastQC analysis on paired-end read fastq files"
    bash scripts/generate_fastqc_report.sh "$data_dir" "$results_dir"

    # Unzip results .zip and delete .zip if successful
    for f in "$results_dir"/*.zip; do unzip "$f" -d "$results_dir"; done

    rm "$results_dir"/*.zip
    rm "$results_dir"/*.html



    # Summarize read quality, GC content, adapter contamination, duplication
    # make summary report file and set headers
touch "$results_dir/summary_report.tsv"
headers="sample"$'\t'"median_quality"$'\t'"base_Q20"$'\t'"base_Q30"$'\t'"gc"$'\t'"adapter_max"$'\t'"adapter_source"$'\t'"adapter_classif"$'\t'"deduplication"$'\t'"duplication"
echo "$headers" >> "$results_dir/summary_report.tsv"

# --- Summarize read quality, GC content, adapter contamination, duplication.
for sample in "${samples[@]}"; do
    bash scripts/trace.sh "Getting fastQC reports for $sample"
    reports=()
    data_source="fastqc_data.txt"
    for i in {1..2}; do
      # Add data source file to reports array
      reports+=("$results_dir/${sample}_${i}_fastqc/$data_source")
    done
    bash scripts/generate_qc_summary_report.sh "$results_dir" "$sample" "${reports[@]}"
done



# Deliverables (within Group File):
  # 1–2 QC plots
  # 1 table of raw read counts and duplicates
