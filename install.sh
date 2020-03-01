#!/bin/bash
dir=$(pwd)

ln -fsv $dir/.zsh_auto_complete $HOME
ln -fsv $dir/.aliases $HOME
ln -fsv $dir/.*rc $HOME
ln -fsv $dir/.tmux.conf $HOME
ln -fsv $dir/.gitconfig $HOME

ln -fsv $dir/.oh-my-zsh/themes/* $HOME/.oh-my-zsh/themes
ln -fsv $dir/bin $HOME/.bin
ln -fsv $dir/.vim $HOME
ln -fsv $dir/.tmuxinator $HOME
ln -fsv $dir/p10k.zsh $HOME/.p10k.zsh
ln -fsv $dir/.Xresources-* $HOME

mkdir $HOME/Code
ln -fsv $dir/Code/key_ok.png $HOME/Code
