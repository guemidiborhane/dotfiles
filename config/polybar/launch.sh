#!/usr/bin/env sh

notify-send -u low "autorandr: restarting polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bars
BAR_NAME=main
BAR_CONFIG=/home/$USER/.config/polybar/config

MAIN_EXTER="HDMI-0"

external_monitor=$(xrandr --query | grep $MAIN_EXTER)
if [[ $external_monitor = *connected* ]]; then
    MONITOR=$MAIN_EXTER TRAY_POS="right" polybar --reload -c $BAR_CONFIG $BAR_NAME &
    sleep 1
fi
