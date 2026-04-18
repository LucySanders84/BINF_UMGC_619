#!/usr/bin/env bash
# Parameters:
PROJECT="$1"
shopt -s nullglob

GENOME=$(bash scripts/get_files.sh \
  "$PROJECT"/data/reference/*.fasta \
  "$PROJECT"/data/reference/*.fasta.gz \
  "$PROJECT"/data/reference/*.fna \
  "$PROJECT"/data/reference/*.fna.gz)

# if GENOME file is a .gz then gunzip
if [[ "$GENOME" == *.gz ]]; then
    gunzip "$GENOME" > "${GENOME%.*}"
fi

# check for genome index, if not found index genome
index=("$PROJECT"/data/reference/genome_index*.ht2)

if [ ${#index[@]} -eq 0 ]; then
    # build genome index
    hisat2-build "$GENOME" "$PROJECT"/data/reference/genome_index
else
    bash scripts/trace.sh "Genome is already indexed, continuing to alignment"
fi

# for each sample perform alignment against GENOME and create sorted BAM and BAI
while IFS=$'\t' read -r SAMPLE R1 R2; do
    #perform alignment pipe to samtools to create sorted BAM
    bash scripts/trace.sh "HISAT2 is aligning $SAMPLE"
    hisat2 \
      -x "$PROJECT/data/reference/genome_index" \
      -1 "$R1" \
      -2 "$R2" \
      2> "$PROJECT/logs/${SAMPLE}_hisat2.log" \
    | (bash scripts/trace.sh "SAMtools is sorting ${SAMPLE}.bam"; \
        samtools sort -o "$PROJECT/data/aligned/${SAMPLE}.bam")

    # index BAM file
    bash scripts/trace.sh "SAMtools is indexing sorted ${SAMPLE}.bam"
    samtools index "$PROJECT/data/aligned/${SAMPLE}.bam"
done < <(bash scripts/paired_end_reads.sh "$PROJECT"/data/trimmed)


