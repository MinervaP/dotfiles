#!/bin/sh

if [ -z $DOTPATH ]; then
  echo '$DOTPATH is not set'
  exit 1
fi

dotfiles=(Brewfile .gitconfig .zshrc .vimrc .tmux.conf .vimperatorrc .xvimrc .pryrc)
for file in ${dotfiles[@]}; do
  ln -sf "$DOTPATH/$file" "$HOME/$file"
done
