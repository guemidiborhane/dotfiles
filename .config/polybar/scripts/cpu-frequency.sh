#!/bin/sh

c=0;t=0

awk '/MHz/ {print $4}' < /proc/cpuinfo | (while read -r i
do
    t=$( echo "$t + $i" | bc )
    c=$((c+1))
done

# min_frequency=$(echo "scale=2; $(cat /proc/cpuinfo | grep MHz | sort -n | head -1 | awk '/MHz/ {print $4}') / 1000" | bc)
avg_frequency=$(echo "scale=2; $t / $c / 1000" | bc)
# max_frequency=$(echo "scale=2; $(cat /proc/cpuinfo | grep MHz | sort -n | tail -1 | awk '/MHz/ {print $4}') / 1000" | bc)


# echo "$min_frequency $avg_frequency $max_frequency" | awk '{print  $2"GHz   | "$1"GHz   " $3 "GHz"}')
echo $avg_frequency"GHz")
