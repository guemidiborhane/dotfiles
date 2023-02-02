#!/bin/sh
# vim: set ft=sh sw=4 et :

install_vundle () {
    if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
        echo "Installing Vundle"
        git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
    fi
}

install_vim_plugins () {
    vim +PluginInstall +qall
}

update_vim_plugins () {
    vim +PluginUpdate +PluginClean +qall
}

configure_vim () {
    install_vundle
    install_vim_plugins
}
