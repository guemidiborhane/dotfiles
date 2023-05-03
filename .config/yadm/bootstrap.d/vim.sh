#!/bin/sh
# vim: set ft=sh sw=4 et :

. "$HOME/.config/yadm/bootstrap.d/utils.sh"

install_vim () {
    if [ ! -x "$(command -v neovim)" ]; then
        echo "Installing neovim"
        yay -S --noconfirm --needed neovim ripgrep
    fi
}

install_nvchad () {
    if [ ! -d "$HOME/.config/nvim" ]; then
        echo "Installing NvChad"
        git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
        ln -s ~/.config/custom-nvim ~/.config/nvim/lua/custom
        nvim
    fi
}

update_vim_plugins () {
    nvim +NvChadUpdate +MasonInstallAll
}

configure_vim () {
    install_vim
    install_nvchad
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
