# vi: set ft=fish :

fish_vi_key_bindings
function fish_greeting
    fastfetch
end

function starship_transient_prompt_func
  starship module character
end

function starship_transient_rprompt_func
  starship module time
end

set -Ux PAGER less
set -Ux EDITOR nvim
set -Ux VISUAL nvim

set -gx ANSIBLE_NOCOWS true

set -gx PATH "$PATH:$HOME/.local/bin"
set -gx PATH "$PATH:$HOME/.krew/bin"

set -gx BAT_THEME "Dracula"

source /opt/asdf-vm/asdf.fish
set -gx ASDF_GOLANG_MOD_VERSION_ENABLED true
. ~/.asdf/plugins/golang/set-env.fish

zoxide init --cmd cd fish | source
set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --reverse"
fzf --fish | source
source /usr/share/doc/find-the-command/ftc.fish quiet
fish_ssh_agent

if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx i3 -- -keeptty
    end
end

starship init fish | source
enable_transience

# Required for touchscreen gestures in firefox
set -gx MOZ_USE_XINPUT2 1
