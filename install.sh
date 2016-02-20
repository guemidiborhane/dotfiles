#!/bin/bash
dir=$(pwd)

ln -fsv $dir/.zsh_auto_complete $HOME
ln -fsv $dir/.aliases $HOME
ln -fsv $dir/.zshrc $HOME
ln -fsv $dir/.tmux.conf $HOME

ln -fsv $dir/.oh-my-zsh/themes/* $HOME/.oh-my-zsh/themes 