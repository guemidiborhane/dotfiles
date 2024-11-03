#!/usr/bin/env sh
# vim: set ft=sh sw=4 et :

CONFIG="$HOME/.config/waybar/config.jsonc"
STYLE="$HOME/.config/waybar/style.css"
CONFIG_FILES="$HOME/.config/waybar/config.jsonc $HOME/.config/waybar/style.css"

unset GDK_BACKEND

killall -q waybar

# Wait until the processes have been shut down
while pgrep -u $UID -x waybar >/dev/null; do sleep 1; done

mode="${1:-run}"
cmd="waybar --config $CONFIG --style $STYLE"

if [[ "$mode" = "dev" ]]; then
    while true; do
        WATCH_FILES="$CONFIG $STYLE"
        $cmd --log-level=debug &
        inotifywait -e create,modify $WATCH_FILES
        killall waybar
    done
elif [[ "$mode" = "run" ]]; then
    $cmd --log-level=warning &
fi
