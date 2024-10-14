if test $status -eq 0
  and test -z "$TMUX"
  and test -n "$SSH_TTY"
  tn workshop&& kill $fish_pid
end


# vim ft=fish
