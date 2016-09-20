#!/bin/sh

if [ -z $DOTPATH ]; then
  echo '$DOTPATH is not set'
  exit 1
fi

if [ $(uname -s) != 'Darwin' ]; then
  echo 'The install script can run only on OS X'
  exit 1
fi

echo 'Linking dotfiles...'
source "$DOTPATH/deploy.sh"

if [ ! `which brew` ]; then
  echo 'Installing Homebrew...'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
echo 'Installing Homebrew packages...'
brew tap homebrew/brewdler
brew bundle

if [ ! `which anyenv` ]; then
  echo 'Installing anyenv...'
  git clone https://github.com/riywo/anyenv "$HOME/.anyenv"
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
fi

echo 'Installing **envs...'
anyenv install rbenv
anyenv install pyenv
anyenv install ndenv

sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
chsh -s /usr/local/bin/zsh

echo 'Installing vimpager...'
make install -C "$DOTPATH/vimpager"

exec $SHELL -l
