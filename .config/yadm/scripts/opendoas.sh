#!/bin/sh
# vim: set ft=sh sw=4 et :

. "$HOME/.config/yadm/scripts/utils.sh"

install_opendoas () {
    if [ ! -x "$(command -v doas)" ]; then
        echo "Installing doas"
        yay -S --noconfirm opendoas
    fi
}

configure_opendoas () {
    echo 'permit persist setenv { XAUTHORITY LANG LC_ALL } :wheel' | sudo tee /etc/doas.conf &>/dev/null
    sudo chown -c root:root /etc/doas.conf
    sudo chmod -c 0400 /etc/doas.conf
}

uninstall_sudo () {
    sudo pacman -Rns --noconfirm sudo
}

opendoas_sudo_link () {
    doas ln -s $(which doas) /usr/bin/sudo
}

opendoas_main () {
    section "opendoas"
    ask "Configure opendoas"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        install_opendoas
        configure_opendoas
        uninstall_sudo
        opendoas_sudo_link
    fi
}
