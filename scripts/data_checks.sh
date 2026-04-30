#!/usr/bin/env bash

#Parameters: data directory
DATA_DIR="$1"

# Helpers
single_file_check() {
    shopt -s nullglob
    local FILE_NAME="$1"
    RESULTS=(${@:2})

    # Check if less than one file
    if [ "${#RESULTS[@]}" -lt 1 ]; then
      bash scripts/trace.sh "$FILE_NAME not found in $DATA_DIR. Exiting pipeline"; exit 1
    fi
    # Check if more than one file
    if [ "${#RESULTS[@]}" -gt 1 ]; then
      bash scripts/trace.sh "More than one $FILE_NAME found in $DATA_DIR. Exiting pipeline"; exit 1
    fi

    bash scripts/trace.sh "$FILE_NAME: ${RESULTS[*]}. Continuing"
}

# check for data files in data dir
FASTQ=("$DATA_DIR"/*.fastq)
# check for at least 2 fastq files
if [ "${#FASTQ[@]}" -lt 2 ]; then
  bash scripts/trace.sh "Less than two .fastq files in $DATA_DIR. Exiting pipeline"; exit 1
fi
# check there are an even number of .fastq files (quick test for 2 fastq files for each sample)
if (( "${#FASTQ[@]}" % 2 != 0 )); then
  bash scripts/trace.sh "Paired reads required, check that each sample has two .fastq files in $DATA_DIR. Exiting pipeline"; exit 1
fi
# check for one genome file
single_file_check "genome reference" "${DATA_DIR}/*.fasta" "${DATA_DIR}/*.fna" || exit 1

# check for one .gff annotation file
single_file_check "annotation reference" "${DATA_DIR}/*.gff" || exit 1