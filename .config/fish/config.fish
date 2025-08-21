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
set -Ux ANSIBLE_NOCOWS true
set -Ux BAT_THEME Dracula
set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --reverse"

if status is-interactive
    zoxide init --cmd cd fish | source
    starship init fish | source
    set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
    carapace _carapace | source
    mise activate fish | source
    atuin init fish --disable-up-arrow | source
    dr --completion fish | source

    fish_vi_key_bindings
    enable_transience
end
