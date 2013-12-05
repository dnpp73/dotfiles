# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# ------------ この先 oh-my-zsh ------------

ZSH=$HOME/.oh-my-zsh

ZSH_THEME="original"

# CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"
DISABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under VCS as dirty. This makes repository status check for large repositories much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(autojump brew git git-extras osx ruby bundler gem rbenv screen pod rsync)

source $ZSH/oh-my-zsh.sh

# ------------ この先は oh-my-zsh じゃなくて多分 homebrew が書いた ------------

fpath=(/usr/local/share/zsh-completions $fpath)

# ------------ この先は oh-my-zsh じゃなくて自前で書いた ------------

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
safe_source "$ORG_DIR/zsh_alias.common"

# Mac or Ubuntu zsh_alias
if [ `uname` = "Darwin" ]; then
    safe_source "$ORG_DIR/zsh_alias.osx"
elif [ `uname` = "Linux" ]; then
    safe_source "$ORG_DIR/zsh_alias.ubuntu"
fi

# end empty line
echo ""
