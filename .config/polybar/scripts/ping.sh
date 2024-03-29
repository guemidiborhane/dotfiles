#!/bin/sh

HOST=1.1.1.1
log=/tmp/ping.log


ping -q -w1 -c1 $HOST &>/dev/null || exit

ping=""

while [ -z "$ping" ]; do
  ping=$(ping -n -c 1 -W 1 $HOST)
done

function icon() {
    if [ "$1" -lt 50 ]; then
        icon="󰓅"
    elif [ "$1" -lt 150 ]; then
        icon="󰾅"
    else
        icon="󰾆"
    fi

    echo "$icon"

}

function text_color() {
    if [ "$1" -lt 50 ]; then
        color="%{F#3cb703}"
    elif [ "$1" -lt 150 ]; then
        color="%{F#f9dd04}"
    else
        color="%{F#d60606}"
    fi
    echo "$color"
}

function output() {
    echo "$(text_color $1)$1 ms%{F-}"
}

function avg() {
    avg=$(tail -n $1 $log | awk '{ total += $1; count++ } END { printf "%3.0f\n", total/count }')
    echo "$(output $avg)"
}

rtt=$(echo "$ping" | sed -rn 's/.*time=([0-9]{1,})\.?[0-9]{0,} ms.*/\1/p')
if [ ! -z "$rtt" ]; then
    echo $rtt >> $log
    echo "$(tail -n 100 $log)" > $log

    color="%{F#01977a}"
    avg=$(avg 100 | awk -F '}' '{print $2}' | awk '{print $1}')
    echo "$color $(icon $avg) %{F-}$color $(avg 10)$color avg: $(avg 100) $color"
fi

killall -9 $(basename $0) &>/dev/null
