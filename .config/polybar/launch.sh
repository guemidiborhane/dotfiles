#!/usr/bin/env sh

notify-send -u low "autorandr: restarting polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bars
BAR_CONFIG=/home/$USER/.config/polybar/config.ini

DISPLAYS=$(xrandr --query | grep ' connected' | awk '{print $1}')

for monitor in ${DISPLAYS[@]}; do
  external_monitor=$(xrandr --query | grep $monitor)
  if [[ $external_monitor = *connected* ]]; then
    MONITOR=$monitor polybar -c $BAR_CONFIG $monitor 2>&1 | tee -a /tmp/polybar-$monitor.log & disown
    sleep 1
  fi
done
