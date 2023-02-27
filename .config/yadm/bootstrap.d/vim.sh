#!/bin/sh
# vim: set ft=sh sw=4 et :

. "$HOME/.config/yadm/bootstrap.d/utils.sh"

install_vim () {
    if [ ! -x "$(command -v vim)" ]; then
        echo "Installing vim"
        yay -S --noconfirm vim
    fi
}
install_vim_plugins () {
    vim +PlugInstall +qall
}

update_vim_plugins () {
    vim +PlugUpdate +PlugClean +qall
}

configure_vim () {
    install_vim
    install_vim_plugins
}

vim_main () {
    section "VIM"
    ask "Install/Update vim"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        if [ -d "$HOME/.vim/bundle/Vundle.vim" ]; then
            update_vim_plugins
        else
            configure_vim
        fi
    fi
}
