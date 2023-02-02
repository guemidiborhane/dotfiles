#!/bin/sh
# vim: set ft=sh sw=4 et :

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
THIRD_PARTY_PLUGINS=(
    zsh-autosuggestions
    zsh-syntax-highlighting
)

install_zsh_pkg () {
    yay -S --needed --noconfirm zsh
}

install_omz () {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    fi
}

update_omz () {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Updating Oh My Zsh"
        omz update
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

install_zsh_plugins () {
    for plugin in "${THIRD_PARTY_PLUGINS[@]}"; do
        if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
            echo "Installing $plugin in $ZSH_CUSTOM/plugins/$plugin"
            git clone https://github.com/zsh-users/$plugin.git "$ZSH_CUSTOM/plugins/$plugin"
        fi
    done
}

update_zsh_plugins () {
    for plugin in "${THIRD_PARTY_PLUGINS[@]}"; do
        if [ -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
            echo "Updating $plugin in $ZSH_CUSTOM/plugins/$plugin"
            git -C "$ZSH_CUSTOM/plugins/$plugin" pull
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
