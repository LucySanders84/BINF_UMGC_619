#!/bin/bash

declare -A CONFIG
CONFIG_FILE="config.cfg"

# Parse line-by-line while ignoring comments and empty lines
while IFS='=' read -r key value; do
    # Skip comments and empty lines
    [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
    # Strip leading/trailing whitespace and quotes
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs | sed 's/^"//;s/"$//')
    CONFIG["$key"]="$value"
done < "$CONFIG_FILE"

# Access variables
echo "${CONFIG[@]}"
