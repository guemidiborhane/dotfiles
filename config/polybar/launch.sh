#!/usr/bin/env sh

notify-send -u low "autorandr: restarting polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bars
external_monitor=$(xrandr --query | grep 'DP-1-1')
if [[ $external_monitor = *connected* ]]; then
      polybar -r external &
fi

polybar -r center &

hdmi_monitor=$(xrandr --query | grep 'HDMI-1-0')
if [[ $external_monitor = *connected* ]]; then
      polybar -r hdmi &
fi
