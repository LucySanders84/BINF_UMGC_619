#!/usr/bin/env bash

# This script checks if fastq files are already available
# for each provided SRA run.
# If user has not placed fastq files in data/raw directory,
# the SRA files are downloaded and split into paired read
# fastq files. Parameters: (raw data directory, SRA run ids)

RAW_DIR="$1"
SRAs=("${@:2}")
download=1
# For each SRA ID
for sra in "${SRAs[@]}"; do
    fastq_1="${sra}_1.fastq"
    fastq_2="${sra}_2.fastq"

    # check if paired end read fastq files exist already
    bash scripts/trace.sh "Checking for $sra fastq files"
    if [[ -f "$RAW_DIR/$fastq_1" && -f "$RAW_DIR/$fastq_2" ]]; then
        # Continue with existing files
        echo "$fastq_1 and $fastq_2 already exist in $RAW_DIR."
        download=0
    fi

    # if download required:
    if [[ $download == 1 ]]; then
        # use SRA toolkit's prefetch tool to obtain each run
        bash scripts/trace.sh "Fetching $sra"
        prefetch "$sra"

        # use SRA toolkit's fasterq-dump tool to split run into paired_read fastq files
        bash scripts/trace.sh "Splitting $sra into paired-read fastq files"
        fasterq-dump "$sra" --split-files -O "$RAW_DIR"
    fi
    download=1
done

