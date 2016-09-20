#!/bin/sh

dotfiles=(Brewfile .gitconfig .zshrc .vimrc .tmux.conf .vimperatorrc .xvimrc .pryrc)
for file in ${dotfiles[@]}; do
  ln -sf ~/dotfiles/$file ~/$file
done
