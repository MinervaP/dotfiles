# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit -u
# End of lines added by compinstall

# -------------------------------------
# anyenv
# -------------------------------------
if [ -d ${HOME}/.anyenv ] ; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
fi

# -------------------------------------
# zplug
# -------------------------------------
# zplugがないときはクローンする
source ~/.zplug/init.zsh || { git clone https://github.com/b4b4r07/zplug.git ~/.zplug && source ~/.zplug/init.zsh }

zplug 'b4b4r07/zplug', at:v2  # don't forget to zplug update --self && zplug update

zplug 'bhilburn/powerlevel9k', use:powerlevel9k.zsh-theme

zplug 'junegunn/fzf-bin', \
    as:command, \
    from:gh-r, \
    rename-to:fzf

zplug 'zsh-users/zsh-syntax-highlighting'

zplug 'zsh-users/zsh-completions'
zplug 'minerva1129/zsh-more-completions'

zplug 'minerva1129/zsh-autosuggestions'

zplug 'b4b4r07/enhancd', use:init.sh

zplug 'simonwhitaker/gibo', as:command, use:gibo

zplug 'stedolan/jq', from:gh-r, as:command, rename-to:jq

# check コマンドで未インストール項目があるかどうか verbose にチェックし
# false のとき（つまり未インストール項目がある）y/N プロンプトで
# インストールする
if ! zplug check --verbose; then
    printf 'Install? [y/N]: '
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
# そのた
# -------------------------------------
# jjでノーマルモードに戻る
bindkey -M viins 'jj' vi-cmd-mode
# powerlevel9kの設定
POWERLEVEL9K_MODE='awesome-patched'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon status_joined background_jobs_joined root_indicator_joined context_joined dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vi_mode)
POWERLEVEL9K_OS_ICON_BACKGROUND='234'
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'
POWERLEVEL9K_SHORTEN_DELIMITER=''
# enahancdの設定
ENHANCD_FILTER=fzf
# zsh-autosuggestions の設定
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=11'
# 選択中の補完候補に色を付ける
zstyle ':completion:*:default' menu select=2
# dotfilesをdotをつけずに補完する
setopt globdots
# 拡張glob
setopt extended_glob
# パスだけで自動でcd
setopt auto_cd
# 入力しているコマンド名が間違っている場合にもしかして：を出す
setopt correct
# ビープを鳴らさない
setopt no_beep
# 色を使う
setopt prompt_subst
# ^dでログアウトしない
setopt ignore_eof
# バックグラウンドジョブが終了したらすぐに知らせる
setopt notify
# 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
# シェル間で履歴を共有しない
setopt no_share_history
# lsの省略
function chpwd() {
  if [ 20 -gt `ls -1 | wc -l` ]; then
    ls -aG
  else
    ls -G
  fi
}

# -------------------------------------
# エイリアス
# -------------------------------------
alias remem='du -sx / &> /dev/null & sleep 25 && kill $!'
alias ls='ls -aG'
alias restart="exec $SHELL -l"
alias pskl="ps aux | fzf | awk '{ print \$2 }' | xargs kill"
function his() {
  print -z $(fc -l 1 | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# -------------------------------------

# プラグインを読み込み、コマンドにパスを通す
zplug load --verbose

# tmux自動attach
function automatically_attach_tmux() {
  if [ -z "$TMUX" ]; then
    if tmux has-session > /dev/null; then
      tmux attach -t $(tmux list-session | fzf | cut -d ':' -f 1)
    else
      tmux new-session
    fi
  else
    echo 'Using tmux...'
  fi
}
automatically_attach_tmux

