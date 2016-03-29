# -------------------------------------
# zplugの設定
# -------------------------------------
source ~/.zplug/zplug

zplug "b4b4r07/zplug"  # don't forget to zplug update --self && zplug update

zplug "themes/agnoster", from:oh-my-zsh

# zplug "sorin-ionescu/prezto", of:init.zsh, do:"ln -s $ZPLUG_HOME/repos/sorin-ionescu/prezto ~/.zprezto"
# zstyle ':prezto:*:*' color 'yes'
# zstyle ':prezto:load' pmodule 'environment' 'history' 'terminal' 'utility' 'tmux'
# zstyle ':prezto:module:terminal' auto-title 'yes'

zplug "zsh-users/zsh-syntax-highlighting", nice:10

zplug "zsh-users/zsh-completions"

zplug "mrowa44/emojify", as:command

zplug "b4b4r07/enhancd", of:enhancd.sh

# check コマンドで未インストール項目があるかどうか verbose にチェックし
# false のとき（つまり未インストール項目がある）y/N プロンプトで
# インストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# プラグインを読み込み、コマンドにパスを通す
zplug load --verbose


# -------------------------------------
# 環境変数
# -------------------------------------
export PATH="/usr/local/bin:/opt/local/bin:/opt/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"
export LANG=ja_JP.UTF-8
fpath=(~/.zsh/completion $fpath)

#rbenvのパス
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# SSHで接続した先で日本語が使えるようにする
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# エディタ
export EDITOR=/usr/local/bin/vim

# ページャ
export PAGER=/usr/local/bin/vimpager
export MANPAGER=/usr/local/bin/vimpager

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT=$HOME/cocos2d-x-3.3/tools/cocos2d-console/bin
export PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable COCOS_X_ROOT for cocos2d-x
export COCOS_X_ROOT=$HOME/cocos2d-x-3.3
export PATH=$COCOS_X_ROOT:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
export COCOS_TEMPLATES_ROOT=$HOME/cocos2d-x-3.3/templates
export PATH=$COCOS_TEMPLATES_ROOT:$PATH

# Add environment variable ANT_ROOT for cocos2d-x
export ANT_ROOT=/usr/local/Cellar/ant/1.9.4/libexec/bin
export PATH=$ANT_ROOT:$PATH

# nodebrewのパス
export PATH=$HOME/.nodebrew/current/bin:$PATH

export DEFAULT_USER=Minerva


# -------------------------------------
# zshのオプション
# -------------------------------------

# 補完機能の強化
autoload -Uz compinit
compinit

# 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct

# ビープを鳴らさない
setopt nobeep

# 色を使う
setopt prompt_subst

# ^Dでログアウトしない。
setopt ignoreeof

# バックグラウンドジョブが終了したらすぐに知らせる。
setopt no_tify

# 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space

# シェル間で履歴を共有しない
setopt no_SHARE_HISTORY

# -------------------------------------
# その他
# -------------------------------------

# lsの省略
function chpwd() { ls }
# enhancdの設定
export ENHANCD_FILTER="/usr/local/bin/peco"

# pecoの設定
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

alias -s txt='cat'
alias -s rb='ruby'
alias -s py='python'
alias -s zip='unzip'
alias -s {gif,jpg,jpeg,png,bmp}='display'

alias cask='brew cask'

alias onkeyboard="sudo kextload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext"
alias offkeyboard="sudo kextunload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext"
alias remem='du -sx / &> /dev/null & sleep 25 && kill $!'

alias ls='ls -a'

alias restart='exec $SHELL -l'
