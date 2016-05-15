#!/bin/sh

if [ ! $(uname -s) == "Darwin" ]; then

  echo "The install script can run only on OS X"
  exit 1

else

echo "Linking dotfiles ..."

ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.pryrc ~/.pryrc
ln -sf ~/dotfiles/.vimperatorrc ~/.vimperatorrc
ln -sf ~/dotfiles/Brewfile ~/Brewfile

if [ ! `which brew` ]; then
  echo "Installing Homebrew ..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Using Homebrew"

brew tap homebrew/brewdler
brew bundle

fi
