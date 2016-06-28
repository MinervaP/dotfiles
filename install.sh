#!/bin/sh

if [ ! $(uname -s) == 'Darwin' ]; then
  echo 'The install script can run only on OS X'
  exit 1
fi

pushd ~

echo 'Linking dotfiles...'
dotfiles=(Brewfile .gitconfig .zshrc .vimrc .tmux.conf .vimperatorrc .xvimrc .pryrc)
for file in ${dotfiles[@]}; do
  ln -sf ~/dotfiles/$file ~/$file
done

if [ ! `which brew` ]; then
  echo 'Installing Homebrew...'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo 'Installing Homebrew packages...'
brew tap homebrew/brewdler
brew bundle

if [ ! `which anyenv` ]; then
  echo 'Installing anyenv...'
  git clone https://github.com/riywo/anyenv ~/.anyenv
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
pushd ~/dotfiles/vimpager
make install
popd

popd
zsh
