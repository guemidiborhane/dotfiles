#!/bin/sh
# vim: set ft=sh sw=4 et :

. "$HOME/.config/yadm/scripts/utils.sh"

install_vim () {
    if [ ! -x "$(command -v vim)" ]; then
        echo "Installing vim"
        yay -S --noconfirm vim
    fi
}

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
    install_vim
    install_vundle
    install_vim_plugins
}

vim_main () {
    section "VIM"
    ask "Configure vim"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        configure_vim
    else
        ask "Update vim plugins"
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            update_vim_plugins
        fi
    fi
}