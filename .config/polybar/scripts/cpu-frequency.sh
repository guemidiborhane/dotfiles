#!/bin/sh

~/.local/bin/core_frequencies | sort -k3 -r | head -1 | awk '{print $3 " " $4}' | xargs -I {} echo "󰾅 {}"
