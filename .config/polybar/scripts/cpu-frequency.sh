#!/bin/sh

c=0
t=0

awk '/MHz/ {print $4}' </proc/cpuinfo | (
	while read -r i; do
		t=$(echo "$t + $i" | bc)
		c=$((c + 1))
	done

	avg_frequency=$(echo "scale=2; $t / $c / 1000" | bc)
	icon=""
	if [ $(echo "$avg_frequency < 3.4" | bc) -eq 1 ]; then
		icon="󰾆"
	elif [ $(echo "$avg_frequency < 4" | bc) -eq 1 ]; then
		icon="󰾅"
	else
		icon="󰓅"
	fi

	echo "$icon $avg_frequency GHz"
)
