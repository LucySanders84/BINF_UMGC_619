#!/usr/bin/env bash

shopt -s nullglob

files=("${@}")

if [ ${#files[@]} -eq 0 ]; then
    echo "No files found"
else
    printf '%s\n' "${files[@]}"
fi