#!/bin/sh
# vim: set ft=sh sw=4 et :

. "$HOME/.config/yadm/bootstrap.d/utils.sh"

clean_slate() {
    echo "Cleaning up"
    yay -Scc --noconfirm

    echo "Updating repositories"
    yay -Syy
}

_configure_docker () {
tee $HOME/.docker/config.json &>/dev/null <<EOF
    {
        "credsStore": "secretservice"
    }
EOF
sudo usermod -aG docker $USER
}

configure_docker () {
    ask "Configure docker"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        _configure_docker
    fi
}

ask_run_all_scripts () {
    ask "Run all scripts"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        INSTALL_ALL=yes
    fi
}

local_bin_permissions () {
    echo "Setting permissions for $HOME/.local/bin"
    chmod -R 755 $HOME/.local/bin
}
