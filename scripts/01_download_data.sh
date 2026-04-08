#!/usr/bin/env bash

# This script checks if fastq files are already available
# for each provided SRA run.
# If user has not placed fastq files in data/raw directory,
# the SRA files are downloaded and split into paired read
# fastq files. Parameters: (raw data directory, SRA run ids)

RAW_DIR="$1"
SRAs=("${@:2}")

# For each SRA ID
for sra in "${SRAs[@]}"; do
    fastq_1="$RAW_DIR/${sra}_1.fastq"
    fastq_2="$RAW_DIR${sra}_2.fastq"

    # check if paired end read fastq files exist already
    if [[ -f "$fastq_1" && -f "$fastq_2" ]]; then
        # Alert user that pipeline will use the stored fastq files
        echo "$fastq_1 and $fastq_2 exist."
        echo "Using stored fastq files. To download new fastq files, delete existing from storage."
    else
        # use SRA toolkit's prefetch tool to obtain each run
        echo "Fetching $sra...."
        prefetch "$sra"

        # use SRA toolkit's fasterq-dump tool to split run into paired_read fastq files
        echo "Splitting $sra into paired read fastq files..."
        fasterq-dump "$sra" --split-files -O "$RAW_DIR"
    fi
done

