#!/bin/sh
# vim: set ft=sh sw=4 et :


bars_ini_path="$HOME/.config/polybar/conf.d/bars.ini"

_default_content () {
    echo "# vim: ft=dosini sw=4 et :"
}

_bar_content () {
echo "
[bar/$1]
inherit = bar/default
# tray-position = right
modules-right = cputemp cpu memory time
"
}

touch_polybar_bars_ini () {
    if [[ ! -f $bars_ini_path ]]; then
        echo "Creating $bars_ini_path"
        echo "$(_default_content)" > $bars_ini_path
    fi
}

configure_polybar () {
    if [[ ! -f $bars_ini_path ]]; then
        echo "Adding default bars to $bars_ini_path"
        touch_polybar_bars_ini
        DISPLAYS=$(xrandr --query | grep ' connected' | awk '{print $1}')
        for monitor in ${DISPLAYS[@]}; do
            echo "$(_bar_content $monitor)" >> $bars_ini_path
        done
    fi
}
