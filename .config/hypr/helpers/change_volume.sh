#!/bin/bash
# PATH: ~/.local/bin/change_volume

# ICONS: https://www.flaticon.com/packs/multimedia-356 (volume-up, volume-down, volume-mute), credit: Freepik, SeyfDesigner

# This script is used to change the volume of the default sink
# It takes one argument, which is the percentage to change the volume by
# If the argument is negative, the volume will be decreased
# If the argument is positive, the volume will be increased
# If the argument is 0, the volume will be muted
# If the argument is 100, the volume will be unmuted
# Then show a notification with the volume bar

default_sink=$(pactl info | grep 'Default Sink' | awk '{print $3}')

function get_info() {
    pactl list sinks | grep -A8 "Name: $default_sink"
}

function get_volume() {
    get_info | grep 'Volume:' | grep -Eo '[0-9]+%' | head -n 1 | sed 's/%//g'
}

# Get the current volume
current_volume=$(get_volume)
# Get the mute status
mute_status=$(get_info | grep 'Mute:' | awk '{print $2}')

# Get the argument
change="$1"

new_volume="$((current_volume + change))"
if [[ "$new_volume" -gt 100 ]]; then
    new_volume=100
fi
# Change the volume
if [[ "$change" = "toggle" ]]; then
    pactl set-sink-mute "$default_sink" toggle
    if [[ "$mute_status" == "yes" ]]; then
        icon="up"
    else
        icon="mute"
        current_volume=0
    fi
elif [[ "$change" -gt 0 ]]; then
    # If the volume is already at 100, don't do anything
    if [[ "$current_volume" -lt 100 ]]; then
        pactl set-sink-mute "$default_sink" off
        pactl set-sink-volume "$default_sink" "$new_volume%"
    fi
    icon="up"
else
    pactl set-sink-mute "$default_sink" off
    pactl set-sink-volume "$default_sink" "$new_volume%"
    icon="down"
fi

current_volume=$(get_volume)

# Show the notification
notify-send \
    -r 9991 \
    -i "$HOME/.icons/volume-$icon.png" \
    -h int:value:"$current_volume" \
    -h string:synchronous:"volume" \
    "Volume" \
    "$current_volume%"
