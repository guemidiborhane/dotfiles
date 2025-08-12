#!/bin/bash

WALLPAPER_DIR="$HOME/.wallpaper"
CACHE_DIR="$HOME/.cache/wallpaper"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

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

get_random_wallpaper() {
  find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1
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

  local source_info=$(magick identify -format "%wx%h" "$source")
  local source_width=$(echo "$source_info" | cut -d'x' -f1)
  local source_height=$(echo "$source_info" | cut -d'x' -f2)

  local target_width=$(echo "$target_resolution" | cut -d'x' -f1)
  local target_height=$(echo "$target_resolution" | cut -d'x' -f2)

  echo "  Processing: ${source_width}x${source_height} -> ${target_width}x${target_height}"

  if [ "$source_width" -gt "$((target_width * 2))" ] || [ "$source_height" -gt "$((target_height * 2))" ]; then
    # Image is significantly larger than target, resize first for performance
    echo "  Large image detected, resizing before blur..."
    magick "$source" \
      -resize "${target_resolution}^" \
      -gravity center \
      -extent "$target_resolution" \
      -gaussian-blur "0x${blur_sigma}" \
      -fill black -colorize "$dim_level"% \
      "$output"
  else
    # Image is reasonable size, blur at full resolution then resize
    magick "$source" \
      -gaussian-blur "0x${blur_sigma}" \
      -resize "${target_resolution}^" \
      -gravity center \
      -extent "$target_resolution" \
      -fill black -colorize "$dim_level"% \
      "$output"
  fi
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
  killall -q hyprpaper

  while pgrep -u $UID -x hyprpaper >/dev/null; do sleep 1; done

  hyprpaper &
  disown
}

main() {
  wallpaper=$(get_random_wallpaper)

  if [ -z "$wallpaper" ]; then
    echo "Error: No wallpapers found in $WALLPAPER_DIR"
    exit 1
  fi

  echo "Selected wallpaper: $(basename "$wallpaper")"

  extension=$(get_extension "$wallpaper")

  primary_monitor=$(hyprctl monitors -j | jq -r '.[0].name')

  while IFS= read -r monitor_line; do
    read -r monitor width height <<<"$monitor_line"
    resolution="${width}x${height}"

    echo "Processing monitor: $monitor ($resolution)"

    monitor_wallpaper="$CACHE_DIR/$monitor.$extension"
    monitor_lock="$CACHE_DIR/$monitor-lock.$extension"

    rm -f "$CACHE_DIR/$monitor."* "$CACHE_DIR/$monitor-lock."*

    # Create monitor-specific wallpaper (optional - comment out if you prefer symbolic links)
    # create_monitor_wallpaper "$wallpaper" "$monitor_wallpaper" "$resolution"

    # Or use symbolic link for wallpaper (lighter on storage)
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
    echo

  done < <(get_monitor_info)

  echo "Wallpaper update complete!"
}

main

restart_hyprpaper
