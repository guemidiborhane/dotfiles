#!/bin/sh
task="$(make -npq | awk -v RS= -F: '$1 ~ /^[^#%.]+$/ { print $1 }' | fzf-tmux -p)"
breakout_type="$(echo -e 'window\nhsplit\nvsplit' | fzf-tmux -p)"
tmux_command=""

case "$breakout_type" in
'window')
  tmux_command="new-window -n $task"
  ;;
'hsplit')
  tmux_command='split-window -h'
  ;;
'vsplit')
  tmux_command='split-window'
  ;;
esac

sh -c "tmux $tmux_command -c '#{pane_current_path}' 'make $task'"
