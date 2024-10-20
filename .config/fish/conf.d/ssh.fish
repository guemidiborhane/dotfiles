if test $status -eq 0
  and test -z "$TMUX"
  and test -n "$SSH_TTY"
  exec tmux new-session -As workshop
end


# vim ft=fish
