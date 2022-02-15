#!/bin/bash

workspaces=$(i3-msg -t get_workspaces | jq '.[].name' | cut -d"\"" -f2)

rm -f $HOME/.i3/i3-resurrect/workspace_*.json

for workspace in $workspaces; do
    i3-resurrect save -w $workspace
    echo "Saved workspace $workspace"
done
