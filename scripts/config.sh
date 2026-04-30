#!/usr/bin/env bash

# Helper: get param from arg > env > default/required
get_param() {
  local arg="$1"
  local env_val="$2"
  local default="$3"
  local name="$4"

  local value="${arg:-${env_val:-$default}}"

  if [[ -z "$value" ]]; then
    bash scripts/trace.sh "Error: $name must be provided. Exiting pipeline"
    exit 1
  fi

  echo "$value"
}