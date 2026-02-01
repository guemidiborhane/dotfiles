# vi: set ft=fish :

set -gx EDITOR nvim
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

set -x LESS -rF
set -Ux PAGER less -R
set -Ux MANPAGER nvim +Man!

set -Ux ANSIBLE_NOCOWS true
set -Ux BAT_THEME Dracula
set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --reverse"

set -q SSH_AUTH_SOCK; or set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"

fish_add_path -mg "$HOME/.local/bin" "$HOME/.krew/bin"

if status is-interactive
    zoxide init --cmd cd fish | source
    starship init fish | source
    atuin init fish --disable-up-arrow | source
    dr --completion fish | source
    mise activate fish | source
    fish_vi_key_bindings
    enable_transience
else
    mise activate fish --shims | source
end
