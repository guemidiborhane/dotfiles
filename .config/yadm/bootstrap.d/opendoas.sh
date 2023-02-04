#!/bin/sh
# vim: set ft=sh sw=4 et :

. "$HOME/.config/yadm/scripts/utils.sh"

doas_conf='permit persist setenv { XAUTHORITY LANG LC_ALL } :wheel'
doas_conf_path='/etc/doas.conf'

install_opendoas () {
    if [ ! -x "$(command -v doas)" ]; then
        echo "Installing doas"
        yay -S --noconfirm opendoas
    fi
}

configure_opendoas () {
    if [[ ! -f $doas_conf_path ]]; then
        sudo touch "$doas_conf_path"
        echo "$doas_conf" | sudo tee "$doas_conf_path"
        sudo chown -c root:root "$doas_conf_path"
        sudo chmod -c 0400 "$doas_conf_path"
    else
        echo "doas.conf already exists"
        echo "if you want to change it, do it manually"
        if [[ ! -f $doas_conf_path.yadm ]]; then
            sudo touch "$doas_conf_path.yadm"
            echo "$doas_conf" | sudo tee "$doas_conf_path.yadm"
        fi
        echo "you can find my config in $doas_conf_path.yadm"
    fi
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
