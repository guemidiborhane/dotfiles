#!/bin/sh
# Exit if no Makefile present
[ ! -f Makefile ] && exit 0

task="$(make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' | sort -u | fzf-tmux -p)"

# Exit if task is empty/cancelled
[ -z "$task" ] && exit 0

breakout_type="$(echo -e 'window\nhsplit\nvsplit' | fzf-tmux -p)"

# Exit if breakout_type is empty/cancelled
[ -z "$breakout_type" ] && exit 0

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
