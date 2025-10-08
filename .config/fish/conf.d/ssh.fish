status is-interactive; or exit

if test $status -eq 0
    and test -z "$TMUX"
    and test -n "$SSH_TTY"
    exec sh -c 'tmux -u new-session -As workshop'
end

# vim ft=fish
