#!/bin/bash
dir=$(pwd)

rm -r $HOME/.i3/
ln -fsv $dir/i3/ $HOME/.config/i3
ln -fsv $dir/config/* $HOME/.config/

ln -fsv $dir/easystroke $HOME/.easystroke

ln -fsv $dir/zshrc $HOME/.zshrc
ln -fsv $dir/p10k.zsh $HOME/.p10k.zsh
ln -fsv $dir/aliases $HOME/.aliases
ln -fsv $dir/functions.zsh $HOME/.functions.zsh

ln -fsv $dir/vimrc $HOME/.vimrc
ln -fsv $dir/vim $HOME/.vim

ln -fsv $dir/gemrc $HOME/.gemrc
ln -fsv $dir/railsrc $HOME/.railsrc

ln -fsv $dir/tmux.conf $HOME/.tmux.conf

ln -fsv $dir/gitconfig $HOME/.gitconfig

ln -fsv $dir/bin $HOME/.bin
ln -fsv $dir/Xresources $HOME/.Xresources
ln -fsv $dir/icons $HOME/.script-icons

mkdir $HOME/Code

chmod +x $dir/.i3/scripts/*.sh
