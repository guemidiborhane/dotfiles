# vi: set ft=fish :

set -g fish_greeting

set -Ux PAGER less
set -Ux EDITOR nvim
set -Ux VISUAL nvim

set -gx ANSIBLE_NOCOWS true

set -gx PATH "$PATH:$HOME/.local/bin"
set -gx PATH "$PATH:$HOME/.krew/bin"

zoxide init --cmd cd fish | source

set -gx MCFLY_RESULTS_SORT "LAST_RUN"
set -gx MCFLY_RESULTS 100
mcfly init fish | source

source /opt/asdf-vm/asdf.fish
set -gx ASDF_GOLANG_MOD_VERSION_ENABLED true
. ~/.asdf/plugins/golang/set-env.fish

starship init fish | source

if status --is-login
  figlet -w $(tput cols) -f "ANSI Shadow.flf" 'I Rock, you suck. Stinson out!' | lolcat
end

fish_ssh_agent

