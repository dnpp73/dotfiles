# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# constants
C_DIR=$(cd $(dirname "$BASH_SOURCE") && pwd)
ORG_DIR="$C_DIR"
[ -L "$BASH_SOURCE" ] && ORG_DIR=$(cd $(dirname $(readlink "$BASH_SOURCE")) && pwd)


# functions
function safe_source() {
    if [ -s "$1" ]; then
        echo "...reading $1"
        . "$1"
    else
        echo "[WARNING] can not read $1"
    fi
}


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
