# vi: set ft=fish :

if status is-interactive
    zoxide init --cmd cd fish | source
    starship init fish | source
    atuin init fish --disable-up-arrow | source
    dr --completion fish | source
    mise activate fish | source
    direnv hook fish | source
    fish_vi_key_bindings
    enable_transience
else
    mise activate fish --shims | source
end
