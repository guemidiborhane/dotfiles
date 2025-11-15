#!/usr/bin/env bash

current_path="${1}"
default_path_format="relative"
PATH_FORMAT="${PATH_FORMAT:-$default_path_format}"

# Check user requested format
if [[ ${PATH_FORMAT} == "relative" ]]; then
  current_path="$(echo ${current_path} | sed 's#'"$HOME"'#~#g')"
fi

# Determine if current path is in a git repository
if git -C "${1}" rev-parse --is-inside-work-tree &>/dev/null; then
  # Git repository detected, use git branch icon
  icon=""
else
  # Not a git repository, use folder icon
  icon=""
fi

echo " ${icon} ${current_path} "
