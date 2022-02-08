#!/usr/bin/env sh

notify-send -u low "autorandr: restarting polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bars
BAR_NAME=main
BAR_CONFIG=/home/$USER/.config/polybar/config

DISPLAYS=$(xrandr --query | grep ' connected' | awk '{print $1}')

for monitor in ${DISPLAYS[@]}; do
  external_monitor=$(xrandr --query | grep $monitor)
  if [[ $external_monitor = *connected* ]]; then

    if [[ $external_monitor = *primary* ]]; then
        MONITOR=$monitor TRAY_POS="right" polybar --reload -c $BAR_CONFIG $BAR_NAME &
        echo "Primary monitor connected: $monitor"
    else
        MONITOR=$monitor TRAY_POS="" polybar --reload -c $BAR_CONFIG $BAR_NAME &
    fi

    sleep 1
  fi
done

