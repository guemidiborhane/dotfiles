#!/bin/bash

# Configuration
WALLPAPER_DIR="$HOME/.wallpaper"
CACHE_DIR="$HOME/.cache/wallpaper"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Function to get all connected monitors
get_monitors() {
  hyprctl monitors -j | jq -r '.[].name'
}

# Function to get a random wallpaper
get_random_wallpaper() {
  find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1
}

# Function to get file extension
get_extension() {
  local filename="$1"
  echo "${filename##*.}"
}

# Create dimmed and blurred version for lock screen
create_lock_background() {
  local source="$1"
  local output="$2"

  local dim_level=40
  local blur_level=1
  local blur_shrink=$(echo "scale=2; 20 / $blur_level" | bc)
  local blur_sigma=$(echo "scale=2; 0.6 * $blur_level" | bc)

  magick convert "$source" \
    -fill black -colorize "$dim_level"% \
    -filter Gaussian \
    -resize "$blur_shrink%" \
    -define "filter:sigma=$blur_sigma" \
    "$output"
}

restart_hyprpaper() {
  killall -q hyprpaper

  # Wait until the processes have been shut down
  while pgrep -u $UID -x hyprpaper >/dev/null; do sleep 1; done

  hyprpaper
}

# Main execution
main() {
  # Get random wallpaper
  wallpaper=$(get_random_wallpaper)

  if [ -z "$wallpaper" ]; then
    echo "Error: No wallpapers found in $WALLPAPER_DIR"
    exit 1
  fi

  # Get the extension of the source wallpaper
  extension=$(get_extension "$wallpaper")

  # Process each monitor
  for monitor in $(get_monitors); do
    # Create symbolic links for wallpaper and lock screen
    monitor_wallpaper="$CACHE_DIR/$monitor.$extension"
    monitor_lock="$CACHE_DIR/$monitor-lock.$extension"

    # Remove old files if they exist
    rm -f "$CACHE_DIR/$monitor."* "$CACHE_DIR/$monitor-lock."*

    # Create new links and files
    ln -sf "$wallpaper" "$monitor_wallpaper"
    create_lock_background "$wallpaper" "$monitor_lock"

    # If this is the primary monitor, create additional links for hyprlock
    if [ "$monitor" = "$(hyprctl monitors -j | jq -r '.[0].name')" ]; then
      rm -f "$CACHE_DIR/primary-lock."*
      ln -sf "$monitor_lock" "$CACHE_DIR/primary-lock.$extension"
    fi

    echo "Set wallpaper for $monitor: $monitor_wallpaper"
    echo "Created lock screen for $monitor: $monitor_lock"
  done

  echo "Wallpaper update complete!"
}

# Run main function
main

restart_hyprpaper
