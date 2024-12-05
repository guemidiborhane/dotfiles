#!/bin/bash

status=$(cat /sys/class/power_supply/BAT0/status)

declare -A status_icons=(
  ["Charging"]="󱐋"
  ["Not charging"]=""
)

echo "${status_icons[$status]}"
