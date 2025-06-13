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

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less -R

if status is-interactive
    set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
    carapace _carapace | source
    zoxide init --cmd cd fish | source
    fzf --fish | source
    source /usr/share/doc/find-the-command/ftc.fish quiet noupdate

    mise activate fish | source
    starship init fish | source
    atuin init fish | source
    fish_vi_key_bindings
    enable_transience
end
