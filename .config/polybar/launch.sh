#!/usr/bin/env sh
# vim: set ft=sh sw=4 et :

killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bars
BAR_CONFIG=/home/$USER/.config/polybar/config.ini

DISPLAYS=$(xrandr --query | grep ' connected' | awk '{print $1}')
for i in /sys/class/hwmon/hwmon*/temp*_input; do
    if [ "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*}))" = "k10temp: Tctl" ]; then
        export HWMON_PATH="$i"
    fi
done

for monitor in ${DISPLAYS[@]}; do
    external_monitor=$(xrandr --query | grep $monitor)
    if [[ $external_monitor = *connected* ]]; then
        MONITOR=$monitor polybar -c $BAR_CONFIG $monitor --log=warning&
    fi
done
