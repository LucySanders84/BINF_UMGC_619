#!/usr/bin/env bash

# This script checks if fastq files are already available
# for each provided sra run.
# If user has not placed fastq files in data/raw directory,
# the sra files are downloaded and split into paired read
# fastq files. Parameters: (raw data directory, sra run ids)

raw_dir="$1"
sra="$2"

fastq_1="$raw_dir/${sra}_1.fastq"
fastq_2="$raw_dir${sra}_2.fastq"

# check if paired end read fastq files exist already
if [[ -f "$fastq_1" && -f "$fastq_2" ]]; then
    # Alert user that pipeline will use the stored fastq files
    echo "$fastq_1 and $fastq_2 exist."
    echo "Using stored fastq files. To download new fastq files, delete existing from storage."
else
    # use sra toolkit's prefetch tool to obtain each run
    echo "Fetching $sra...."
    prefetch "$sra"

    # use sra toolkit's fasterq-dump tool to split run into paired_read fastq files
    echo "Splitting $sra into paired read fastq files..."
    fasterq-dump "$sra" --split-files -O "$raw_dir"
fi


