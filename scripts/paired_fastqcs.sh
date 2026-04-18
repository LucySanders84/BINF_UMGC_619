#!/usr/bin/env bash

#Parameters:
DIR="$1"

shopt -s nullglob

# For each *_1_fastqc_data.txt file in dir, find matching *_2_fastqc_data.txt
for R1 in "$DIR"/*_1_fastqc*; do
    # get sample id from filename
    if [[ "$R1" != *.html ]]; then
        REST="${R1#*_1_}"
        SAMPLE=$(basename "$R1" "_1_$REST")
        R2="$DIR/${SAMPLE}_2_$REST"
        #check to make sure R2 exists
        if [ ! -f "$R2" ]; then
            echo "Missing pair for $R1" >&2
            continue
        fi
        printf '%s\t%s\t%s\n' "$SAMPLE" "$R1" "$R2"
    fi
done