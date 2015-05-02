# If not running interactively, don't do anything
[ -z "$PS1" ] && return


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


# start empty line
echo ""


# common bashrc
safe_source "$ORG_DIR/bashrc.common"

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


unset -f safe_source


# ssh-add
KEY_FILES=("id_rsa_beatrobo" "id_rsa")
for key in ${KEY_FILES[@]}; do
    ssh-add "${HOME}/.ssh/${key}" > /dev/null 2>&1
done
unset KEY_FILES


# screen 先でも困らないようにするやつ
AGENT_SOCK_FILE="/tmp/ssh-agent-${USER}@`hostname`"
if test $SSH_AUTH_SOCK ; then
  if [ $SSH_AUTH_SOCK != $AGENT_SOCK_FILE ] ; then
    ln -sf $SSH_AUTH_SOCK $AGENT_SOCK_FILE
    export SSH_AUTH_SOCK=$AGENT_SOCK_FILE
  fi
fi
unset AGENT_SOCK_FILE


# とりあえず
if [ -s "${HOME}/.bashrc_local" ]; then
    echo ""
    echo "...loading ${HOME}/.bashrc_local"
    . "${HOME}/.bashrc_local"
fi


# added by travis gem
[ -f "${HOME}/.travis/travis.sh" ] && source "${HOME}/.travis/travis.sh"


# end empty line
echo ""
