#!/bin/sh
# vim: set ft=sh sw=4 et :

. "$HOME/.config/yadm/bootstrap.d/utils.sh"

clean_slate() {
    echo "Cleaning up"
    yay -Scc --noconfirm

    echo "Updating repositories"
    yay -Syy
}

install_packages () {
    section "Packages"
    ALL_PACKAGES="no"

    ask "Install packages"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        clean_slate
        for package_file in $1; do
            if [ -f "$package_file" ]; then
                category=$(basename $package_file | cut -d'.' -f1)
                section "Installing $category packages"

                if [[ $ALL_PACKAGES == "no" ]]; then
                    ask "Install $category packages", "y/N/a"
                fi

                if [[ $REPLY =~ ^[Aa]$ ]]
                then
                    ALL_PACKAGES="yes"
                fi

                if [[ $REPLY =~ ^[Yy]$ ]] || [[ $ALL_PACKAGES == "yes" ]]
                then
                    yay -S --needed --noconfirm - < $package_file
                fi
            fi
        done
    fi
}

enable_user_services () {
    ask "Enable user services"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        systemctl --user enable --now $@
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

local_bin_permissions () {
    echo "Setting permissions for $HOME/.local/bin"
    chmod -R 755 $HOME/.local/bin
}
