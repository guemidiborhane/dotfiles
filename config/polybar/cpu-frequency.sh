#!/bin/sh
max_frequency=$(awk '/MHz/ {print $4}' < /proc/cpuinfo | awk '{if($1>a)a=$1;}END{print a}')
echo "scale=2; $max_frequency / 1000" | bc | awk '{print $1" GHz"}'
