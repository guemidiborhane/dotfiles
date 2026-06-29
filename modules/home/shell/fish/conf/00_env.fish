# vi: set ft=fish :

set -gx EDITOR nvim
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

set -gx LESS -rF
set -gx PAGER less -R
set -gx MANPAGER nvim +Man!

set -gx ANSIBLE_NOCOWS true
set -gx BAT_THEME Dracula
set -gx FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --reverse"

set -q SSH_AUTH_SOCK; or set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"

fish_add_path -mg "$HOME/.krew/bin"
