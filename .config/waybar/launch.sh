#!/usr/bin/env sh
# vim: set ft=sh sw=4 et :

CONFIG_FILES="$HOME/.config/waybar/config.jsonc $HOME/.config/waybar/style.css"

unset GDK_BACKEND

killall -q waybar

# Wait until the processes have been shut down
while pgrep -u $UID -x waybar >/dev/null; do sleep 1; done

# while true; do
#     waybar &
#     inotifywait -e create,modify $CONFIG_FILES
#     killall waybar
# done

waybar --log-level=warning &
