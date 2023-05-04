#!/usr/bin/bash

DISPLAYS="$(xrandr --listactivemonitors | awk '{ print $4 ";" $1 ";" $3 }' | tail -n+2)"
BASE_URL="unsplash.com"

# exit if no internet connection
ping -q -w1 -c1 $BASE_URL &>/dev/null || exit

paths=""

for screen in ${DISPLAYS[@]}; do
    screen_name=$(echo $screen | cut -d ';' -f 1)
    id=$(echo $screen | cut -d ';' -f 2 | sed 's/[^0-9]*//g')

    resolution=$(echo $screen | cut -d ';' -f 3 | awk -F '[/x+]' '{ print $1 "x" $3 }')
    height=$(echo $resolution | cut -d 'x' -f 2)
    width=$(echo $resolution | cut -d 'x' -f 1)

    uri=$(curl -X GET --silent -I "https://source.$BASE_URL/${width}x${height}/?stars,nature,weather"  | grep -ie "^Location: " | sed 's/^Location: //gi' | tr -d '\r')
    output="/tmp/$id-$screen_name-${width}x${height}.jpg"
    curl -s "$uri" --output "$output"
    paths="$paths $output"
done

DISPLAY=:0 feh --bg-center $paths
# XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send -u low "wallpaper changed"
