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


# Mac /etc/sshd_config check
if [ `uname` = "Darwin" ]; then
    COLOR_GREEN_BOLD='\033[1;32m'
    COLOR_RED_BOLD='\033[1;31m'
    COLOR_OFF='\033[0m'

    echo ""
    echo -n "...checking /etc/sshd_config : "

    diff /etc/sshd_config /etc/sshd_config.etc.osx > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e ${COLOR_GREEN_BOLD}"[OK]"${COLOR_OFF}
    else
        echo -e ${COLOR_RED_BOLD}"[WARNING]"${COLOR_OFF} Check /etc/sshd_config
    fi

    echo -n "...checking /etc/services    : "
    egrep 'ssh\s+22' /etc/services > /dev/null 2>&1 
    if [ $? -ne 0 ]; then
        echo -e ${COLOR_GREEN_BOLD}"[OK]"${COLOR_OFF}
    else
        echo -e ${COLOR_RED_BOLD}"[WARNING]"${COLOR_OFF} Check /etc/services
    fi

    unset COLOR_GREEN_BOLD COLOR_RED_BOLD COLOR_OFF
fi


# ssh-agent について、あればそのまま使って、かつ、 screen 先でも困らないようにするやつ
if [ -s "${HOME}/.env_ssh_auth_sock" ]; then
    . "${HOME}/.env_ssh_auth_sock"
fi


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
