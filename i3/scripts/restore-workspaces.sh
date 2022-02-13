#!/bin/bash

# Terminate already running bar instances
killall -q autotiling

# Wait until the processes have been shut down
while pgrep -u $UID -x autotiling >/dev/null; do sleep 1; done

resurrect_dir=$HOME/.i3/i3-resurrect
files=$(for n in $resurrect_dir/workspace_*_layout.json; do printf '%s\n' "$n"; done)

for file in $files; do
    i3-resurrect restore -w $(basename $file | cut -d'_' -f2)
done

autotiling 2>&1 & disown
