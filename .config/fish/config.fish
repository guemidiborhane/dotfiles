# vi: set ft=fish :

fish_vi_key_bindings
function fish_greeting
    figlet -w $(tput cols) -f "ANSI Shadow.flf" 'I Rock, you suck. Stinson out!' | lolcat
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

