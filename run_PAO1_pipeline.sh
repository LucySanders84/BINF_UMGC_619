#!/usr/bin/env bash
shopt -s nullglob
# Parameters: reset data (optional; if == 1 then project will reset after running)

RESET=${1:-0}
DATA_DIR="test_data2"
PROJECT_PATH="projects"
PROJECT="PAO1_2"
PROJECT_DIR="${PROJECT_PATH}/$PROJECT"

# remove project directory if it exists
if [[ "$PROJECT_PATH" ]]; then
  bash scripts/trace.sh "$PROJECT_DIR already exists. Exiting pipeline"; exit 1
fi

FNA=GCF_000006765.1_ASM676v1/GCF_000006765.1_ASM676v1_genomic.fna.gz
GFF=GCF_000006765.1_ASM676v1/GCF_000006765.1_ASM676v1_genomic.gff.gz
FTP_PATH="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/006/765"

# activate conda env
ENV_NAME=$(sed -n 's/^name: //p' environment.yml)
eval "$(conda shell.bash hook)"

conda activate "$ENV_NAME"

# Download RNA Seq data for PAO1 species
bash scripts/01_download_data.sh "$DATA_DIR" SRR14995084 SRR14995085 SRR14995086

# Download reference genome and GFF

bash scripts/trace.sh "Setting up reference genome files"
GENOME=("$DATA_DIR"/*.fna "$DATA_DIR"/*.fna.gz)
GFF_FILE=("$DATA_DIR"/*.gff "$DATA_DIR"/*.gff.gz)

if [ ${#GENOME[@]} -eq 0 ]; then
  wget -P "$DATA_DIR" "$FTP_PATH/$FNA"
fi

if [ ${#GFF_FILE[@]} -eq 0 ]; then
  wget -P "$DATA_DIR" "$FTP_PATH/$GFF"
fi

ZIPPED=("$DATA_DIR"/*.gz)
if [ ${#ZIPPED[@]} -gt 0 ]; then
    gunzip "$DATA_DIR"/*.gz
fi

# Run pipeline
bash scripts/run_pipeline.sh "$PROJECT" "$DATA_DIR" "$PROJECT_PATH" || exit 1

if [ "$RESET" == 1 ]; then
    # Reset test data
    bash scripts/trace.sh "Moving data from $PROJECT/data to $DATA_DIR"

    mv "$PROJECT_DIR"/data/raw/*.fastq -t "$DATA_DIR"

    mv "$PROJECT_DIR"/data/reference/*.{gff,fasta,fna} -t "$DATA_DIR"

    mv "$PROJECT_DIR"/data/reference/*genome_index* -t "$DATA_DIR"
fi
