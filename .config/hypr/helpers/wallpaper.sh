#!/bin/bash

WALLPAPER_DIR="$HOME/.wallpaper"
CACHE_DIR="$HOME/.cache/wallpaper"
wallpaper="$1"

# Parse command line flags
INTERACTIVE_MODE=false
REVIEW_MODE=false

while [[ $# -gt 0 ]]; do
  case $1 in
  --interactive)
    INTERACTIVE_MODE=true
    shift
    ;;
  --review)
    REVIEW_MODE=true
    shift
    ;;
  *)
    wallpaper="$1"
    shift
    ;;
  esac
done

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Exit if on battery power
check_battery() {
  if [ -d /sys/class/power_supply ]; then
    for supply in /sys/class/power_supply/BAT*/status; do
      if [ -f "$supply" ]; then
        status=$(cat "$supply")
        if [ "$status" = "Discharging" ]; then
          echo "On battery power, skipping wallpaper update"
          exit 0
        fi
      fi
    done
  fi
}

# Function to get monitor info (name, width, height)
get_monitor_info() {
  hyprctl monitors -j | jq -r '.[] | "\(.name) \(.width) \(.height)"'
}

# Function to get all connected monitors (names only)
get_monitors() {
  hyprctl monitors -j | jq -r '.[].name'
}

get_monitor_resolution() {
  local monitor="$1"
  hyprctl monitors -j | jq -r ".[] | select(.name == \"$monitor\") | \"\(.width)x\(.height)\""
}

get_wallpapers_list() {
  find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \)
}

get_random_wallpaper() {
  if [[ -f "$wallpaper" ]]; then
    echo "$wallpaper"
  else
    get_wallpapers_list | shuf -n 1
  fi
}

get_extension() {
  local filename="$1"
  echo "${filename##*.}"
}

create_lock_background() {
  local source="$1"
  local output="$2"
  local target_resolution="$3" # e.g., "1920x1080"

  local dim_level=40
  local blur_sigma=6

  local target_width=$(echo "$target_resolution" | cut -d'x' -f1)
  local target_height=$(echo "$target_resolution" | cut -d'x' -f2)

  # Use lower quality/faster operations
  # First resize to target (fast), then apply effects
  magick "$source" \
    -resize "${target_resolution}^" \
    -gravity center \
    -extent "$target_resolution" \
    -scale 50% \
    -blur "0x${blur_sigma}" \
    -resize "${target_resolution}!" \
    -fill black -colorize "$dim_level"% \
    -quality 85 \
    "$output"
}

create_monitor_wallpaper() {
  local source="$1"
  local output="$2"
  local target_resolution="$3"

  # For regular wallpaper, we might want to resize to exact monitor resolution
  magick "$source" \
    -resize "${target_resolution}^" \
    -gravity center \
    -extent "$target_resolution" \
    "$output"
}

restart_hyprpaper() {
  systemctl --user restart hyprpaper.service
}

# Process a single monitor (for parallel execution)
process_monitor() {
  local monitor="$1"
  local width="$2"
  local height="$3"
  local wallpaper="$4"
  local extension="$5"
  local primary_monitor="$6"

  local resolution="${width}x${height}"

  echo "Processing monitor: $monitor ($resolution)"

  local monitor_wallpaper="$CACHE_DIR/$monitor.$extension"
  local monitor_lock="$CACHE_DIR/$monitor-lock.$extension"

  rm -f "$CACHE_DIR/$monitor."* "$CACHE_DIR/$monitor-lock."*

  # Use symbolic link for wallpaper (lighter on storage)
  ln -sf "$wallpaper" "$monitor_wallpaper"

  # Create monitor-specific lock screen background
  create_lock_background "$wallpaper" "$monitor_lock" "$resolution"

  # If this is the primary monitor, create additional links for hyprlock
  if [ "$monitor" = "$primary_monitor" ]; then
    rm -f "$CACHE_DIR/primary-lock."*
    ln -sf "$monitor_lock" "$CACHE_DIR/primary-lock.$extension"
    echo "  Created primary lock screen link"
  fi

  echo "  Wallpaper: $monitor_wallpaper"
  echo "  Lock screen: $monitor_lock"
}

# Interactive mode: select wallpaper with fzf and preview
interactive_select() {
  if ! command -v fzf &>/dev/null; then
    echo "Error: fzf is required for interactive mode"
    exit 1
  fi

  if ! command -v chafa &>/dev/null; then
    echo "Error: chafa is required for interactive mode preview"
    exit 1
  fi

  local selected
  selected=$(get_wallpapers_list | dmenu)

  if [ -z "$selected" ]; then
    echo "No wallpaper selected"
    exit 0
  fi

  wallpaper="$selected"
}

# Review mode: iterate through wallpapers and delete unwanted ones
review_wallpapers() {
  echo "Starting wallpaper review..."
  echo ""

  local count=0
  local deleted=0
  local kept=0

  for file in "$WALLPAPER_DIR"/*.jpg; do
    # Check if any files exist (avoid running on literal "*.jpg" if no files found)
    [ -e "$file" ] || continue

    count=$((count + 1))

    # Run the wallpaper script to preview
    "$0" "$file"

    # Ask if file should be deleted
    echo ""
    read -p "Delete $(basename "$file")? (y/n): " response

    case "$response" in
    [Yy]*)
      rm "$file"
      echo "Deleted: $file"
      deleted=$((deleted + 1))
      ;;
    *)
      echo "Kept: $file"
      kept=$((kept + 1))
      ;;
    esac

    echo "---"
  done

  echo ""
  echo "Review complete!"
  echo "Total reviewed: $count"
  echo "Deleted: $deleted"
  echo "Kept: $kept"
}

# Export functions for parallel execution
export -f process_monitor
export -f create_lock_background
export -f get_extension
export CACHE_DIR

main() {
  # Handle review mode
  if [ "$REVIEW_MODE" = true ]; then
    review_wallpapers
    exit 0
  fi

  # Handle interactive mode
  if [ "$INTERACTIVE_MODE" = true ]; then
    interactive_select
  fi

  # Check battery status
  check_battery

  wallpaper=$(get_random_wallpaper)

  if [ -z "$wallpaper" ]; then
    echo "Error: No wallpapers found in $WALLPAPER_DIR"
    exit 1
  fi

  echo "Selected wallpaper: $(basename "$wallpaper")"

  extension=$(get_extension "$wallpaper")

  primary_monitor=$(hyprctl monitors -j | jq -r '.[0].name')

  # Check if GNU parallel is available
  if command -v parallel &>/dev/null; then
    echo "Using parallel processing..."
    get_monitor_info | parallel --colsep ' ' process_monitor {1} {2} {3} "$wallpaper" "$extension" "$primary_monitor"
  else
    echo "GNU parallel not found, processing sequentially..."
    while IFS= read -r monitor_line; do
      read -r monitor width height <<<"$monitor_line"
      process_monitor "$monitor" "$width" "$height" "$wallpaper" "$extension" "$primary_monitor"
      echo
    done < <(get_monitor_info)
  fi

  echo "Wallpaper update complete!"
}

main

restart_hyprpaper
