#!/usr/bin/env bash
# Parameters: message from pipeline step
message="$1"

#set variables
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# print message to console
printf "\n%s RNA-SEQ pipeline: %s...\n" "$TIMESTAMP" "$message"

