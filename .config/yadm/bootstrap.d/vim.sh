#!/bin/sh
# vim: set ft=sh sw=4 et :

. "$HOME/.config/yadm/bootstrap.d/utils.sh"

install_deps () {
    yay -Syy --noconfirm --needed $@
}

install_nvim () {
    if [ ! -x "$(command -v neovim)" ]; then
        echo "Installing neovim"
        install_deps neovim ripgrep bottom lazygit
        nvim --headless +q
    fi
}

update_vim_plugins () {
    nvim +AstroUpdate +q
}

clear_neovim_cache () {
    rm -rf ~/.local/share/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.cache/nvim
}

configure_vim () {
    clear_neovim_cache
    install_nvim
}

vim_main () {
    section "NeoVIM"
    ask "Install/Update neovim"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        if [ -d "$HOME/.config/nvim" ]; then
            update_vim_plugins
        else
            configure_vim
        fi
    fi
}
