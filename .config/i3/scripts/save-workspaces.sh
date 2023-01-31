#!/bin/sh

workspaces=$(i3-msg -t get_workspaces | jq '.[].name' | cut -d"\"" -f2)
dir="$HOME/.config/i3-resurrect"
rm -f $dir/workspace_*.json

for workspace in $workspaces; do
    i3-resurrect save -w $workspace -d $dir
    echo "Saved workspace $workspace"
done
