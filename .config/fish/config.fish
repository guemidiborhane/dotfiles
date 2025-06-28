# vi: set ft=fish :

function fish_greeting
    fastfetch
end

function starship_transient_prompt_func
    starship module character
end

function starship_transient_rprompt_func
    starship module directory
    starship module time
end

set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -Ux PAGER less -R
set -Ux MANPAGER nvim +Man!

if status is-interactive
    zoxide init --cmd cd fish | source
    starship init fish | source
    set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
    carapace _carapace | source
    mise activate fish | source
    atuin init fish --disable-up-arrow | source

    fish_vi_key_bindings
    enable_transience
end
