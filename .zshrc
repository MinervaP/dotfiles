# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename ~/.zshrc

autoload -Uz compinit
compinit -u
# End of lines added by compinstall

# -------------------------------------
# anyenv
# -------------------------------------
if [ -d ~/.anyenv ] ; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init - zsh)"
fi

# -------------------------------------
# zplug
# -------------------------------------
[ -d ~/.zplug ] || curl -sL zplug.sh/installer | zsh
source ~/.zplug/init.zsh

zplug 'zplug/zplug'
zplug 'bhilburn/powerlevel9k', use:powerlevel9k.zsh-theme
zplug 'junegunn/fzf-bin', as:command, from:gh-r, rename-to:fzf
zplug 'seebi/dircolors-solarized'
zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'zsh-users/zsh-history-substring-search'
zplug 'minerva1129/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug 'minerva1129/zsh-more-completions'
zplug 'b4b4r07/enhancd', use:init.sh
zplug 'simonwhitaker/gibo', as:command, use:gibo
zplug 'stedolan/jq', from:gh-r, as:command, rename-to:jq

# 未インストールのものをインストール
if ! zplug check --verbose; then
  echo 'Install? [y/N]: '
  if read -q; then
    echo; zplug install
  fi
fi

# -------------------------------------
# 環境変数
# -------------------------------------
export DEFAULT_USER=Minerva
export TERM='xterm-256color'
export EDITOR=vim
export PAGER=vimpager

# -------------------------------------
# キーバインド
# -------------------------------------
function extended_logout() {
  echo; echo -n 'Logout? [y/N]: '
  if read -q; then
    exit
  else
    zle accept-line
  fi
}
zle -N extended-logout extended_logout
bindkey '^d' extended-logout

function fzf_history() {
  print -z $(history -n -r 1 | awk '!a[$0]++' | fzf --no-sort)
  zle accept-line
}
zle -N fzf-history fzf_history
bindkey '^r' fzf-history

bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down

bindkey '^k' forward-word
bindkey '^o' backward-word

# -------------------------------------
# プラグインの設定
# -------------------------------------
# powerlevel9kの設定
POWERLEVEL9K_MODE='awesome-patched'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon status_joined background_jobs_joined root_indicator_joined context_joined dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_OS_ICON_BACKGROUND='234'
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'
POWERLEVEL9K_SHORTEN_DELIMITER=''
# dircolors-solarizedの設定
eval $(gdircolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.ansi-universal)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# enahancdの設定
ENHANCD_FILTER=fzf
# zsh-autosuggestionsの設定
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=11'

# -------------------------------------
# そのた
# -------------------------------------
setopt no_beep
setopt ignore_eof
setopt notify

setopt correct
setopt globdots
zstyle ':completion:*:default' menu select=2

setopt hist_ignore_dups
setopt hist_ignore_space
setopt no_share_history

setopt auto_cd
function chpwd() {
  if [ $PWD != $HOME ]; then
    if [ 20 -gt `ls -1 | wc -l` ]; then
      gls -AFh --color
    else
      gls -Fh --color
    fi
  fi
}

# fzfでprocessをkill
function kl() {
  ps -u $USER -o pid,stat,%cpu,%mem,cputime,command | fzf | awk '{print $1}' | xargs kill
}

# -------------------------------------
# エイリアス
# -------------------------------------
alias remem='du -sx / &> /dev/null & sleep 25 && kill $!'
alias ls='gls -AFh --color'
alias restart="exec $SHELL -l"

# -------------------------------------
# -------------------------------------
zplug load --verbose

# tmux自動attach
function auto_attach_tmux() {
  if [ -z "$TMUX" ]; then
    if tmux has-session > /dev/null; then
      tmux ls
      echo 'Attach tmux session? [y/N]: '
      read -q && tmux attach -t $(tmux list-session | fzf --select-1 | cut -d ':' -f 1)
    else
      echo 'Create new tmux session? [y/N]: '
      read -q && tmux new-session
    fi
  else
    echo 'Using tmux...'
  fi
}
auto_attach_tmux

