#!/bin/bash

# Terminate already running bar instances
killall -q autotiling

# Wait until the processes have been shut down
while pgrep -u $UID -x autotiling >/dev/null; do sleep 1; done


i3-resurrect restore -w $(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).name' | cut -d"\"" -f2)

autotiling&
