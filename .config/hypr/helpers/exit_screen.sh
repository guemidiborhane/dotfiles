#!/bin/sh
# vim: set ft=sh sw=4 sts=4 et :

if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
    default_screen_height=$(hyprctl monitors -j | jq '.[0].height' -r)
else
    default_screen_height=$(xrandr --query | grep ' primary ' | cut -d ' ' -f 4 | cut -d 'x' -f 2 | cut -d '+' -f 1)
fi
# x = (height * 1440) / 500
padding=$(echo "$default_screen_height * 500 / 1440 * 0.75" | bc)

labels_count=$(grep label ~/.config/wlogout/layout | wc -l)
wlogout --buttons-per-row ${labels_count} --margin-top ${padding} --margin-bottom ${padding} --no-span
