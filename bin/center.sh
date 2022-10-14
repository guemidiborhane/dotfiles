#!/bin/bash

readarray message < <(expand)

width="${1:-$(tput cols)}"

margin=$(awk -v "width=$width" '
    { max_len = length > width ? width : length > max_len ? length : max_len }
    END { printf "%" int((width - max_len + 1) / 2) "s", "" }
' <<< "${message[@]}")

printf "%s" "${message[@]/#/$margin}"
