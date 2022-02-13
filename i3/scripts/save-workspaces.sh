#!/bin/bash

workspaces=$(i3-msg -t get_workspaces | jq '.[].name' | cut -d"\"" -f2)

for workspace in $workspaces; do
    i3-resurrect save -w $workspace
    echo "Saved workspace $workspace"
done
