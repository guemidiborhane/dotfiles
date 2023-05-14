#!/bin/sh
# vim: set ft=sh sw=4 et :

. "$HOME/.config/yadm/bootstrap.d/utils.sh"

install_vim () {
    if [ ! -x "$(command -v neovim)" ]; then
        echo "Installing neovim"
        yay -S --noconfirm --needed neovim ripgrep bottom lazygit 
    fi
}

install_astronvim () {
    if [ ! -d "$HOME/.config/nvim" ]; then
        echo "Installing AstroNvim"
        git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
        ln -s ~/.config/astronvim ~/.config/nvim/lua/user
        nvim --headless -c 'quitall'
    fi
}

update_vim_plugins () {
    nvim +AstroUpdatePackages
}

configure_vim () {
    install_vim
    install_astronvim
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
