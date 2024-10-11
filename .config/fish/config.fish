# vi: set ft=fish :

function fish_greeting
    fastfetch
    echo -e "\r"
end

function starship_transient_prompt_func
  starship module character
end

function starship_transient_rprompt_func
  starship module time
end

zoxide init --cmd cd fish | source
fzf --fish | source
source /usr/share/doc/find-the-command/ftc.fish quiet noupdate

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER  less -R

starship init fish | source
fish_vi_key_bindings
enable_transience

if test $status -eq 0
  and test -z "$TMUX"
  and test -n "$SSH_TTY"
  tn workshop&& kill $fish_pid
end
