#!/usr/bin/env bash

# Parameters: genome reference file
genome="$1"
reference_dir="$2"
samples=("${@:3}")

echo "$genome" "$reference_dir"
# if genome file is a .gz then gunzip
if [[ "$genome" == *.gz ]]; then
    gunzip "$genome" > "${genome%.*}"
fi

# Tools (aligner):
# HISAT2

# check for genome index, if not found index genome
shopt -s nullglob
index=("$reference_dir"/genome_index*.ht2)

if [ ${#index[@]} -eq 0 ]; then
    # build genome index
    hisat2-build "$genome" data/reference/genome_index
else
    scripts/trace.sh "Genome index found"
fi

# for each sample perform alignment against genome and create sorted BAM and BAI
for sample in "${sample[@]}"; do
    #perform alignment pipe to samtools to create sorted BAM
    hisat2 \
      -x data/reference/genome_index \
      -1 data/trimmed/"${sample}_1.fastq" \
      -2 data/trimmed/"${sample}_2.fastq" \
      2> logs/"${sample}_hisat2.log" \
    | samtools sort -o data/aligned/"${sample}.bam"
    # index BAM file
    samtools index data/aligned/"${sample}.bam"
done

# Deliverables (within Group File):
# 1-2 plots or tables of alignment metrics (total reads, mapping %).
# Compile alignment metrics
bash scripts/alignment_metrics.sh "${samples[@]}"

