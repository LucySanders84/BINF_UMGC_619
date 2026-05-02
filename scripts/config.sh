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

LOG_WIDTH=$(tput cols)

calc_half_padding() {
  local message_len=$1

  printf '%*s' "$(( ("$LOG_WIDTH" - "${message_len}") / 2 ))" ""
}

divider_line() {
  # has_divider == 1: print divider, else no divider
  local has_divider=$1
  local width=$2
  if [ "$has_divider" -eq 1 ]; then
    printf -v divider '%*s' "$(( width ))" ""
    echo "${divider// /=}"
  fi
}

decorate_text() {
  local text="$1"
  local padder="$2"
  local half_padding="$3"
  echo "${half_padding// /$padder}${text}${half_padding// /$padder}"
}

space_text() {
  local text=$1
  echo "  $text  "
}
decorate_sub_header() {
  local text="$1"
  local padder="$2"
  local half_padding="$3"
  spacer_len=$(( "$LOG_WIDTH" / 8 ))
  printf -v spacer_padding '%*s' "$spacer_len" ""
  printf -v half_padding '%*s' "$(( ${#half_padding} - spacer_len ))" ""
  echo "${spacer_padding// /" "}${half_padding// /$padder}${text}${half_padding// /$padder}${spacer_padding// /" "}"
}
mark_log_header() {
  local text="$1 running"
  decorator="="
  header=$(space_text "$text")
  d_header=$(decorate_sub_header "$header" $decorator "$(calc_half_padding "${#text}")")

  echo
  echo "$d_header"
}

mark_log_step_header() {
  local header_text="$1"
  local step_text="$2"
  local has_divider=1
  decorator=" "
  header=$(space_text "$header_text")
  step=$(space_text "$step_text")
  d_header=$(decorate_text "$header" "$decorator" "$(calc_half_padding ${#header})")
  d_step=$(decorate_text "$step" "$decorator" "$(calc_half_padding ${#step})")
  if [ ${#d_header} -lt ${#d_step} ]; then
    d_header+="$decorator"
  fi
  if [ ${#d_header} -gt ${#d_step} ]; then
    d_step+="$decorator"
  fi
  echo
  divider_line "$has_divider" ${#d_header}
  echo "$d_header"
  echo "$d_step"
  divider_line "$has_divider" ${#d_header}
  echo
}
