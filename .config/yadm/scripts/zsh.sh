#!/bin/sh
# vim: set ft=sh sw=4 et :

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
THIRD_PARTY_PLUGINS=(
    https://github.com/zsh-users/zsh-autosuggestions.git
    https://github.com/zsh-users/zsh-syntax-highlighting.git
    https://github.com/oldratlee/hacker-quotes.git
)

. "$HOME/.config/yadm/scripts/utils.sh"

install_zsh_pkg () {
    yay -S --needed --noconfirm zsh
    touch "$HOME/.zsh_history" # Fix for mcfly
}

install_omz () {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    fi
}

update_omz () {
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "Not using zsh, skipping Oh My Zsh update"
        return
    fi

    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Updating Oh My Zsh"
        zsh -c "source $HOME/.zshrc; omz update"
    fi
}

install_p10k () {
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        echo "Installing Powerlevel10k in $ZSH_CUSTOM/themes/powerlevel10k"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    fi
}

update_p10k () {
    if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        echo "Updating Powerlevel10k in $ZSH_CUSTOM/themes/powerlevel10k"
        git -C "$ZSH_CUSTOM/themes/powerlevel10k" pull
    fi
}

_plugin_name () {
    basename $1 | cut -d'.' -f1
}

install_zsh_plugins () {
    for plugin in "${THIRD_PARTY_PLUGINS[@]}"; do
        if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
            echo "Installing $plugin in $ZSH_CUSTOM/plugins/$plugin"
            plugin_name=$(_plugin_name $plugin)
            git clone $plugin "$ZSH_CUSTOM/plugins/$plugin_name"
        fi
    done
}

update_zsh_plugins () {
    for plugin in "${THIRD_PARTY_PLUGINS[@]}"; do
        plugin_name=$(_plugin_name $plugin)
        if [ -d "$ZSH_CUSTOM/plugins/$plugin_name" ]; then
            echo "Updating $plugin in $ZSH_CUSTOM/plugins/$plugin"
            git -C "$ZSH_CUSTOM/plugins/$plugin_name" pull
        fi
    done
}

install_zsh () {
    install_zsh_pkg
    install_omz
    install_p10k
    install_zsh_plugins
}

update_zsh () {
    update_omz
    update_p10k
    update_zsh_plugins
}

zsh_main () {
    section "ZSH"

    ask "Install/Update zsh"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        if [ -d "$HOME/.oh-my-zsh" ]; then
            update_zsh
        else
            install_zsh
        fi
    fi
}
