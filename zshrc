# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac


# LANG
case $TERM in
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
#[ -d /usr/local/opt/ruby/bin ] && PATH="/usr/local/opt/ruby/bin:$PATH"
[ -d /usr/local/share/man ] && MANPATH="/usr/local/share/man:$MANPATH"
[ -d /usr/local/opt/coreutils/libexec/gnubin ] && PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
[ -d /usr/local/opt/coreutils/libexec/gnuman ] && MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
[ -d "$HOME/sbin" ] && PATH="$HOME/sbin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
export PATH MANPATH


# EDITOR
if [ -x /usr/local/bin/vim ]; then
    EDITOR=/usr/local/bin/vim; export EDITOR
elif [ -x /usr/bin/vim ]; then
    EDITOR=/usr/bin/vim; export EDITOR
fi


# PAGER
# man とかを見るときはいつも less を使う。
if [ -x /usr/local/bin/less ]; then
    PAGER=/usr/local/bin/less; export PAGER
elif [ -x /usr/bin/less ]; then
    PAGER=/usr/bin/less; export PAGER
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
  export RBENV_ROOT="$rbenv_root"
fi
if [ -n "$rbenv_root" ]; then
  echo ""
  echo "...loading rbenv"
  export PATH="${rbenv_root}/bin:$PATH"
  eval "$(rbenv init -)"
fi


# ------------ ここから oh-my-zsh ------------
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="original"

# CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"
DISABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under VCS as dirty. This makes repository status check for large repositories much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

if [ `uname` = "Darwin" ]; then
    plugins=(osx terminalapp autojump screen rsync sudo brew git git-extras ruby bundler gem rake rbenv pod python vagrant xcode sublime go)
elif [ `uname` = "Linux" ]; then
    plugins=(autojump screen rsync sudo git git-extras ruby bundler gem rake rbenv python go)
fi

echo ""
echo "...loading oh-my-zsh"
source $ZSH/oh-my-zsh.sh


# ------------ ここから homebrew が勝手に追記した分 ------------
fpath=(/usr/local/share/zsh-completions $fpath)


# ------------ ここから自前の alias ------------
function safe_source() {
    if [ -s "$1" ]; then
        echo "...loading $1"
        . "$1"
    else
        echo "[WARNING] can not load $1"
    fi
}

# constants
ZSHRC_PATH="$HOME/.zshrc"
C_DIR=$(cd $(dirname "$ZSHRC_PATH") && pwd)
ORG_DIR="$C_DIR"
[ -L "$ZSHRC_PATH" ] && ORG_DIR=$(cd $(dirname $(readlink "$ZSHRC_PATH")) && pwd)

# start empty line
echo ""

# common zsh_alias
safe_source "${ORG_DIR}/zsh_alias.common"

# Mac or Ubuntu zsh_alias
if [ `uname` = "Darwin" ]; then
    safe_source "${ORG_DIR}/zsh_alias.osx"
elif [ `uname` = "Linux" ]; then
    safe_source "${ORG_DIR}/zsh_alias.ubuntu"
fi


unset -f safe_source


# ------------ 細々 ------------


# ssh-agent について、あればそのまま使って、かつ、 screen 先でも困らないようにするやつ
AGENT_SOCK_FILE="/tmp/ssh-agent-${USER}@`hostname`"
SSH_AGENT_FILE="$HOME/.ssh-agent-info"
KEY_FILES=("id_rsa_beatrobo" "id_rsa")
# if test $SSH_AUTH_SOCK ; then
#   if [ $SSH_AUTH_SOCK != $AGENT_SOCK_FILE ] ; then
#     ln -sf $SSH_AUTH_SOCK $AGENT_SOCK_FILE
#     export SSH_AUTH_SOCK=$AGENT_SOCK_FILE
#   fi
# else
#   test -f $SSH_AGENT_FILE && source $SSH_AGENT_FILE > /dev/null 2>&1
#   if ! ssh-add -l > /dev/null 2>&1 ; then
#     test -f $SSH_AGENT_FILE && rm -rf $SSH_AGENT_FILE
#     ssh-agent > $SSH_AGENT_FILE
#     source $SSH_AGENT_FILE > /dev/null 2>&1
#     for key in ${KEY_FILES[@]}; do
#         ssh-add "${HOME}/.ssh/${key}" > /dev/null 2>&1
#     done
#     ln -sf $SSH_AUTH_SOCK $AGENT_SOCK_FILE
#     export SSH_AUTH_SOCK=$AGENT_SOCK_FILE
#   fi
# fi
unset AGENT_SOCK_FILE SSH_AGENT_FILE KEY_FILES


# とりあえず
if [ -s "${HOME}/.zshrc_local" ]; then
    echo ""
    echo "...loading ${HOME}/.zshrc_local"
    . "${HOME}/.zshrc_local"
fi


# added by travis gem
[ -f "${HOME}/.travis/travis.sh" ] && source "${HOME}/.travis/travis.sh"


# end empty line
echo ""
