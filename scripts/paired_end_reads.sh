#!/usr/bin/env bash

#Parameters:
DIR="$1"

# For each *_1.fastq file in dir, find matching *_2.fastq
for R1 in "$DIR"/*_1.fastq ; do
    # get sample id from filename
    SAMPLE=$(basename "$R1" _1.fastq)
    R2="$DIR/${SAMPLE}_2.fastq"

    #check to make sure R2 exist
    if [ ! -f "$R2" ]; then
        echo "Missing pair for $R1" >&2
        continue
    fi
    printf '%s\t%s\t%s\n' "$SAMPLE" "$R1" "$R2"
done
