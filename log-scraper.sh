#!/bin/bash

declare -A rolling_hash_table
touch ~/output.txt

function add_to_rolling_hash_table() {
  local line="$1"
  local hash=$(rolling_hash "$line")
  if [ ! ${rolling_hash_table["$hash"]+_} ]; then
    echo -e "\033[0;33mHash not in hash table.\033[0m" >&2
    rolling_hash_table[$hash]="$line"
    echo "$line" >> ~/output.txt
  else
    echo -e "\033[0;33mHash already in hash table. Skipping\033[0m" >&2
  fi
}

function rolling_hash() {
  local str="$1"
  str=$(remove_dates_and_numbers "$str")
  echo -e "\033[0;33m$str\033[0m" >&2

  local hash=2166136261
  local fnv_prime=16777619
  local len=${#str}

  for (( i=0; i<$len; i++ )); do
    char=$(printf '%d' "'${str:i:1}")
    hash=$((hash ^ char))
    hash=$((hash * fnv_prime))
  done

  echo -e "\033[0;33m$hash\033[0m" >&2
  echo $hash
}

# Function to remove dates and numbers from a string
function remove_dates_and_numbers() {
  # Regex pattern to match dates in the format Mon DD
  pattern1='(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[[:blank:]]+[0-9]{1,2}'

  # Regex pattern to match dates in the format YYYY-MM-DD
  pattern2='[0-9]{4}-[0-9]{2}-[0-9]{2}'

  # Regex pattern to match any number in the string
  pattern3='[0-9]+'

  # Remove dates and numbers using sed and the regex patterns
  sed -E "s/$pattern1//g; s/$pattern2//g; s/$pattern3//g;" <<< "$1"
}

sudo grep -ri --binary-files=without-match "$1" "$2" | while read -r line; do
  add_to_rolling_hash_table "$line"
done
