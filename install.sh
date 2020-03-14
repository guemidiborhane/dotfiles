#!/bin/bash
dir=$(pwd)

ln -fsv $dir/zshrc $HOME/.zshrc
ln -fsv $dir/vimrc $HOME/.vimrc
ln -fsv $dir/zsh_auto_complete $HOME/.zsh_auto_complete
ln -fsv $dir/aliases $HOME/.aliases
ln -fsv $dir/gemrc $HOME/.gemrc
ln -fsv $dir/railsrc $HOME/.railsrc
ln -fsv $dir/tmux.conf $HOME/.tmux.conf
ln -fsv $dir/gitconfig $HOME/.gitconfig

ln -fsv $dir/bin $HOME/.bin
ln -fsv $dir/vim $HOME/.vim
ln -fsv $dir/p10k.zsh $HOME/.p10k.zsh
ln -fsv $dir/.Xresources $HOME

mkdir $HOME/Code
ln -fsv $dir/Code/key_ok.png $HOME/Code
