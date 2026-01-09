#!/usr/bin/env bash
# PATH: ~/.local/bin/change_brightness

for cmd in brightnessctl notify-send; do
    command -v "$cmd" >/dev/null || {
        echo "$cmd not found"
        exit 1
    }
done

# Check if device supports brightness control
brightnessctl info &>/dev/null || {
    echo "No brightness control available"
    exit 1
}

# Exit if no argument provided
[[ $1 ]] || {
    echo "Usage: $0 <+/-value>"
    exit 1
}

# Set brightness and get new value
case $1 in
+*) arg="${1}%" ;;    # +10 becomes +10%
-*) arg="${1#-}%-" ;; # -10 becomes 10%-
*) arg="${1}%" ;;     # 10 becomes 10%
esac

new_brightness=$(brightnessctl set "$arg" -m | cut -d',' -f4 | tr -d '%')

# Show notification
notify-send \
    -r 9991 \
    -i "$HOME/.icons/brightness.png" \
    -h int:value:"$new_brightness" \
    -h string:synchronous:"brightness" \
    "Brightness" \
    "$new_brightness%"
