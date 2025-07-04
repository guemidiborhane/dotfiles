#!/bin/sh

current_shell=${1}
default_shell="$(basename ${2:-fish})"

main() {
  panes_count=$(tmux list-panes -s | wc -l)

  if [ "$default_shell" = "$current_shell" ]; then
    if [ "$panes_count" -gt 1 ]; then
      tmux send-keys C-d
    else
      if tmux popup -w 25 -h 7 -E gum confirm "kill-pane ?" --default=1 --no-show-help; then
        tmux send-keys C-d
      fi
    fi
  else
    tmux send-keys C-d
  fi

  return 0
}

main
