#!/bin/bash
dir=$(pwd)

ln -fs $dir/.zsh_auto_complete $HOME/ 
ln -fs $dir/.aliases $HOME/ 
ln -fs $dir/.zshrc $HOME/ 
ln -fs $dir/.tmux.conf $HOME/ 