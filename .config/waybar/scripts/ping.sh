#!/bin/sh

HOST=1.1.1.1
log=/tmp/ping.log

# Check initial connectivity
ping -q -w1 -c1 $HOST &>/dev/null || {
    printf '{"text": "󰅙", "tooltip": "No connection", "class": "offline"}\n'
    exit 1
}

ping=""

while [ -z "$ping" ]; do
    ping=$(ping -n -c 1 -W 1 $HOST)
done

get_icon() {
    if [ "$1" -lt 50 ]; then
        echo "󰓅"
    elif [ "$1" -lt 150 ]; then
        echo "󰾅"
    else
        echo "󰾆"
    fi
}

get_class() {
    if [ "$1" -lt 50 ]; then
        echo "good"
    elif [ "$1" -lt 150 ]; then
        echo "warning"
    else
        echo "critical"
    fi
}

calculate_avg() {
    tail -n $1 $log | awk '{ total += $1; count++ } END { printf "%3.0f", total/count }'
}

# Extract RTT from ping output
rtt=$(echo "$ping" | sed -rn 's/.*time=([0-9]{1,})\.?[0-9]{0,} ms.*/\1/p')

if [ ! -z "$rtt" ]; then
    # Update log file
    echo $rtt >> $log
    echo "$(tail -n 100 $log)" > $log

    # Calculate averages
    avg_10=$(calculate_avg 10)
    avg_100=$(calculate_avg 100)

    # Determine icon and class based on 100-ping average
    icon=$(get_icon $avg_100)
    class=$(get_class $avg_100)

    # Create tooltip with detailed information
    tooltip="Last 10 avg: ${avg_10}ms\nLast 100 avg: ${avg_100}ms\nLast ping: ${rtt}ms"

    # Output JSON format for Waybar
    printf '{"text": "%s %dms", "tooltip": "%s", "class": "%s"}\n' \
        "$icon" "$avg_10" "$tooltip" "$class"
else
    # Fallback output if ping fails
    printf '{"text": "󰅙", "tooltip": "Failed to get ping", "class": "offline"}\n'
fi

# Cleanup other instances
killall -9 $(basename $0) &>/dev/null
