#!/bin/bash

# Map governors to icons and descriptions
declare -A governor_icons=(
  ["performance"]="󰓅"  # rocket
  ["powersave"]="󰌪"    # leaf
  ["schedutil"]="󰡴"    # processor
  ["ondemand"]="󰥔"     # gauge/speedometer
  ["conservative"]="󰾅" # balance
  ["userspace"]="󱊫"    # sliders
)

declare -A governor_desc=(
  ["performance"]="Maximum performance, highest power consumption"
  ["powersave"]="Maximum power saving, lowest performance"
  ["schedutil"]="Kernel-based CPU scaling"
  ["ondemand"]="Dynamic frequency scaling"
  ["conservative"]="Gradual frequency scaling"
  ["userspace"]="Manual frequency control"
)

# Function to format frequency
format_freq() {
  freq_khz=$1
  freq_mhz=$(echo "scale=1; $freq_khz/1000" | bc)

  if [ $(echo "$freq_mhz >= 1000" | bc) -eq 1 ]; then
    freq_ghz=$(echo "scale=1; $freq_mhz/1000" | bc)
    # Remove .0 if the number is whole
    freq_ghz=$(echo "$freq_ghz" | sed 's/\.0$//')
    echo "${freq_ghz}GHz"
  else
    # Remove .0 if the number is whole
    freq_mhz=$(echo "$freq_mhz" | sed 's/\.0$//')
    echo "${freq_mhz}MHz"
  fi
}

# Function to get current governor status
get_governor_status() {
  current_governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
  icon=${governor_icons[$current_governor]:-"󰚥"}
  desc=${governor_desc[$current_governor]:-"Unknown governor"}

  # Get min and max frequencies
  min_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq)
  max_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq)

  # Format frequencies
  min_formatted=$(format_freq "$min_freq")
  max_formatted=$(format_freq "$max_freq")

  # Create tooltip with description and frequency range
  tooltip="$desc\nFrequency range: ${min_formatted} - ${max_formatted}"

  # Output JSON
  echo "{\"text\": \"$icon\", \"class\": \"$current_governor\", \"tooltip\": \"$tooltip\"}"
}

# Function to show governor selection menu with icons
set_governor() {
  available_governors=$(sed 's/\s/\n/g' /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)

  # Create menu items with icons
  menu_items=$(echo "$available_governors" | while read -r gov; do
    icon=${governor_icons[$gov]:-"󰚥"}
    echo "$icon $gov"
  done)

  # Show rofi menu and extract selected governor (remove icon)
  selected=$(echo "$menu_items" | rofi -dmenu -p "CPU Governor")
  governor=$(echo "$selected" | awk '{print $2}')

  if [ -n "$governor" ]; then
    pkexec cpupower frequency-set -g "$governor"
  fi
}

# Main execution
case "$1" in
"set")
  set_governor
  ;;
*)
  get_governor_status
  ;;
esac
