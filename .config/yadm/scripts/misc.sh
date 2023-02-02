#!/bin/sh
# vim: set ft=sh sw=4 et :

. "$HOME/.config/yadm/scripts/utils.sh"

clean_slate() {
    echo "Cleaning up"
    yay -Scc --noconfirm

    echo "Updating repositories"
    yay -Syy
}

install_packages () {
    ask "Install packages"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        for package_file in $1; do
            if [ -f "$package_file" ]; then
                echo "Installing packages from $package_file"
                yay -S --needed --noconfirm - < $package_file
            fi
        done
    fi
}

enable_user_services () {
    ask "Enable user services"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        for service in $1; do
            echo "Enabling $service"
            systemctl --user enable --now $service
        done
    fi
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
