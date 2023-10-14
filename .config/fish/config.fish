set -g fish_greeting
set -gx EDITOR "nvim"
set -gx ANSIBLE_NOCOWS true

set -gx PATH "$PATH:$HOME/.local/bin"
set -gx PATH "$PATH:$HOME/.krew/bin"

zoxide init fish | source

set -gx MCFLY_RESULTS_SORT "LAST_RUN"
set -gx MCFLY_RESULTS 100
mcfly init fish | source

set -gx PATH "$PATH:$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin"

source /opt/asdf-vm/asdf.fish
set -gx ASDF_GOLANG_MOD_VERSION_ENABLED true
. ~/.asdf/plugins/golang/set-env.fish

starship init fish | source

if status --is-login
  set -x (gnome-keyring-daemon --start | string split "=")
  figlet -w $(tput cols) -f "ANSI Shadow.flf" 'I Rock, you suck. Stinson out!' | lolcat
end
