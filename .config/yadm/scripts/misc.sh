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
    section "Packages"
    clean_slate

    ask "Install packages"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        for package_file in $1; do
            if [ -f "$package_file" ]; then
                category=$(basename $package_file | cut -d'.' -f1)
                section "Installing $category packages"
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

ask_run_all_scripts () {
    ask "Run all scripts"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        INSTALL_ALL=yes
    fi
}


section () {
    echo
    echo "===================="
    echo " $1"
    echo "===================="
    echo
}

readme () {
echo <<EOF
    REMINDER:
    - Don't forget to run `chsh -s $(which zsh)` to set zsh as your default shell
    - You should probably reboot now ! just to be sure
EOF
}

local_bin_permissions () {
    echo "Setting permissions for $HOME/.local/bin"
    chmod -R 755 $HOME/.local/bin
}
