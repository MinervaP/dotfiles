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

  echo "Installing Homebrew packages ..."
  brew tap homebrew/brewdler
  brew bundle

  if [ ! `which anyenv` ]; then
    echo "Installing anyenv ..."
    git clone https://github.com/riywo/anyenv ~/.anyenv
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
  fi

  echo "Installing **envs ..."
  anyenv install rbenv
  anyenv install pyenv
  anyenv install ndenv

  sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
  chsh -s /usr/local/bin/zsh

  echo "Installing tmux-powerline ..."
  git clone https://github.com/minerva1129/tmux-powerline ~/tmux-powerline

  echo "Installing vimpager ..."
  git clone https://github.com/rkitover/vimpager ~/vimpager
  cd ~/vimpager
  make install
  cd ~

  zsh
fi
