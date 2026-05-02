#!/usr/bin/env bash
# Set nullglob so loops won't run if no files match
shopt -s nullglob

# Parameters: PROJECT (optional, if not provided script uses env var value)

# Source config file
source scripts/config.sh

# Set variables
# get_param function is sourced from config.sh
PROJECT=$(get_param "$1" "$PROJECT" "" "PROJECT")

GENOME_FILES=("$PROJECT"/data/reference/*.fasta "$PROJECT"/data/reference/*.fna)
GENOME="${GENOME_FILES[0]}"

# check for genome index, if not found index genome
index=("$PROJECT"/data/reference/genome_index*.ht2)

if [ ${#index[@]} -eq 0 ]; then
    # build genome index
    bash scripts/trace.sh "Building genome index"
    mark_log_header "HISAT2-BUILD"
    hisat2-build "$GENOME" "$PROJECT"/data/reference/genome_index
else
    bash scripts/trace.sh "Genome is already indexed, continuing to alignment"
fi

# for each sample perform alignment against GENOME and create sorted BAM and BAI
while IFS=$'\t' read -r SAMPLE R1 R2; do
    #perform alignment pipe to samtools to create sorted BAM
    mark_log_header "HISAT2"
    bash scripts/trace.sh "Aligning $SAMPLE to genome reference"
    hisat2 \
      -x "$PROJECT/data/reference/genome_index" \
      -1 "$R1" \
      -2 "$R2" \
      2> "$PROJECT/logs/${SAMPLE}_hisat2.log" \
    | (mark_log_header "SAMTOOLS (SORT)"; \
      bash scripts/trace.sh "Sorting ${SAMPLE}.bam"; \
      samtools sort -o "$PROJECT/data/aligned/${SAMPLE}.bam")

    # index BAM file
    mark_log_header "SAMTOOLS (INDEX)"
    bash scripts/trace.sh "Indexing sorted ${SAMPLE}.bam"
    samtools index "$PROJECT/data/aligned/${SAMPLE}.bam"
done < <(bash scripts/paired_end_reads.sh "$PROJECT"/data/trimmed)


