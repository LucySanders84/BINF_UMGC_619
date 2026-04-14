#!/usr/bin/env bash
raw_dir="$1"
trimmed_dir="$2"
results_dir="$3"
samples=("${@:4}")

for sample in "${samples[@]}"; do
    # Trim adapters, low-quality bases, and discard short reads (<30–50 bp).
    fastp -i "$raw_dir/${sample}_1.fastq" -I "$raw_dir/${sample}_2.fastq" \
    -o "$trimmed_dir/${sample}_1.fastq" -O "$trimmed_dir/${sample}_2.fastq" \
    -h "$results_dir/${sample}_fastp.html" -j "$results_dir/${sample/}_fastp.json"
done


