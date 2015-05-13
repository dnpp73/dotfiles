# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# start empty line
echo ""


# common bashrc
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac


# LANG
case "$TERM" in
    linux) LANG=C ;;
    *) LANG=ja_JP.UTF-8 ;;
esac
export LANG


# PATH
PATH="/usr/bin:/usr/sbin:/bin:/sbin"
MANPATH="/usr/share/man"
[ -d /usr/bin/X11 ] && PATH="$PATH:/usr/bin/X11"
[ -d /usr/games ] && PATH="$PATH:/usr/games"
[ -d /usr/X11 ] && PATH="$PATH:/usr/X11/bin" && MANPATH="$MANPATH:/usr/X11/man"
[ -d /usr/local/sbin ] && PATH="/usr/local/sbin:$PATH"
[ -d /usr/local/bin ] && PATH="/usr/local/bin:$PATH"
[ -d /usr/local/share/man ] && MANPATH="/usr/local/share/man:$MANPATH"
[ -d /usr/local/opt/coreutils/libexec/gnubin ] && PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
[ -d /usr/local/opt/coreutils/libexec/gnuman ] && MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
[ -d "$HOME/sbin" ] && PATH="$HOME/sbin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
export PATH MANPATH


# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# 履歴のサイズ。これで半年ぐらい前のやつまで残る？
HISTSIZE=50000
HISTFILESIZE=50000

# 履歴ファイルを上書きではなく追加する。
shopt -s histappend

# "!"をつかって履歴上のコマンドを実行するとき、
# 実行するまえに必ず展開結果を確認できるようにする。
shopt -s histverify

# 履歴の置換に失敗したときやり直せるようにする。
shopt -s histreedit

# 端末の画面サイズを自動認識。
shopt -s checkwinsize

# "@" のあとにホスト名を補完させない。
shopt -u hostcomplete

# つねにパス名のテーブルをチェックする。
shopt -s checkhash

# なにも入力してないときはコマンド名を補完しない。
shopt -s no_empty_cmd_completion


# bash_completion
if [ -s /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
elif [ -s /etc/bash_completion ]; then
    . /etc/bash_completion
fi


# EDITOR
if [ -x /usr/local/bin/vim ]; then
    EDITOR=/usr/local/bin/vim
    export EDITOR
elif [ -x /usr/bin/vim ]; then
    EDITOR=/usr/bin/vim
    export EDITOR
fi


# PAGER
# man とかを見るときはいつも less を使う。
if [ -x /usr/local/bin/less ]; then
    PAGER=/usr/local/bin/less
    export PAGER
elif [ -x /usr/bin/less ]; then
    PAGER=/usr/bin/less
    export PAGER
fi

# less
# ステータス行にファイル名と行数、いま何%かを表示するようにする。
export LESS='-R -X -i -P ?f%f:(stdin).  ?lb%lb?L/%L..  [?eEOF:?pb%pb\%..]'

# これを設定しないと日本語がでない less もあるので一応入れておく。
export JLESSCHARSET=japanese-ujis

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# rbenv
if [ -s "${HOME}/.rbenv/bin" ]; then
  rbenv_root="${HOME}/.rbenv"
elif [ -s "/usr/local/rbenv" ]; then
  rbenv_root="/usr/local/rbenv"
fi
if [ -n "$rbenv_root" ]; then
  echo ""
  echo "...loading rbenv"
  export PATH="${rbenv_root}/bin:$PATH"
  export RBENV_ROOT="$rbenv_root"
  eval "$(rbenv init -)"
fi


# 細々とした設定。
#set -o emacs
set -o ignoreeof
set -o noclobber
BLOCKSIZE=k; export BLOCKSIZE
export HISTTIMEFORMAT="%y/%m/%d %T "
#export TERM="xterm-color"
#export TERM="screen-256color"
#bind '"\033[3~": delete-char'
bind '"\e[5~": backward-kill-word'
bind '"\e[6~": kill-word'
bind '"\033[H": beginning-of-line'
bind '"\033[F": end-of-line'
bind '"\C-a": beginning-of-line'
bind '"\C-e": end-of-line'
bind '"\C-l": clear-screen'


# constants
C_DIR=$(cd $(dirname "$BASH_SOURCE") && pwd)
ORG_DIR="$C_DIR"
[ -L "$BASH_SOURCE" ] && ORG_DIR=$(cd $(dirname $(readlink "$BASH_SOURCE")) && pwd)


# functions
function safe_source() {
    if [ -s "$1" ]; then
        echo "...loading $1"
        . "$1"
    else
        echo "[WARNING] can not load $1"
    fi
}


# Mac or Ubuntu bashrc
if [ `uname` = "Darwin" ]; then
    safe_source "$ORG_DIR/bashrc.osx"
elif [ `uname` = "Linux" ]; then
    safe_source "$ORG_DIR/bashrc.ubuntu"
fi


# alias
unalias -a

# common bash_alias
safe_source "$ORG_DIR/bash_alias.common"

# Mac or Ubuntu bash_alias
if [ `uname` = "Darwin" ]; then
    safe_source "$ORG_DIR/bash_alias.osx"
elif [ `uname` = "Linux" ]; then
    safe_source "$ORG_DIR/bash_alias.ubuntu"
fi


# ssh-agent について、あればそのまま使って、かつ、 screen 先でも困らないようにするやつ
if [ -s "${ORG_DIR}/env_ssh_auth_sock" ]; then
    safe_source "${ORG_DIR}/env_ssh_auth_sock"
fi


# 最後に local があれば
if [ -s "${HOME}/.bashrc_local" ]; then
    safe_source "${HOME}/.bashrc_local"
fi


# Mac /etc/sshd_config check
if [ `uname` = "Darwin" ]; then
    safe_source "$ORG_DIR/check_osx_sshd_config"
fi


unset -f safe_source


# added by travis gem
[ -f "${HOME}/.travis/travis.sh" ] && source "${HOME}/.travis/travis.sh"


# end empty line
echo ""
