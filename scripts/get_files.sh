#!/usr/bin/env bash

shopt -s nullglob

files=("${@}")

if [ ${#files[@]} -eq 0 ]; then
    bash scripts/trace.sh "No files found"
else
    printf '%s\n' "${files[@]}"
fi