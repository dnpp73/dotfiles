# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# よく使うログ出し source 関数
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


# common
safe_source "${ORG_DIR}/common_shrc"


# oh-my-zsh
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="original"

# CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"
DISABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under VCS as dirty. This makes repository status check for large repositories much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

if [ `uname` = "Darwin" ]; then
    plugins=(osx terminalapp autojump screen sudo brew git git-extras ruby bundler gem rake rbenv pod vagrant docker docker-compose pyenv virtualenv pip)
elif [ `uname` = "Linux" ]; then
    plugins=(ubuntu autojump screen sudo git git-extras ruby bundler gem rake rbenv pyenv virtualenv pip)
fi

echo ""
echo "...loading oh-my-zsh"
source $ZSH/oh-my-zsh.sh
echo ""


# homebrew が勝手に追記したやつ
fpath=(/usr/local/share/zsh-completions $fpath)


# common alias
safe_source "${ORG_DIR}/common_sh_alias"


# Mac or Ubuntu alias
if [ `uname` = "Darwin" ]; then
    safe_source "${ORG_DIR}/common_sh_alias_osx"
elif [ `uname` = "Linux" ]; then
    safe_source "${ORG_DIR}/common_sh_alias_ubuntu"
fi


# ssh-agent について、あればそのまま使って、かつ、 screen 先でも困らないようにするやつ
if [ -s "${ORG_DIR}/env_ssh_auth_sock" ]; then
    safe_source "${ORG_DIR}/env_ssh_auth_sock"
fi


# 最後に local があれば
if [ -s "${HOME}/.zshrc_local" ]; then
    safe_source "${HOME}/.zshrc_local"
fi


# Mac /etc/sshd_config check
if [ `uname` = "Darwin" ]; then
    source "$ORG_DIR/check_osx_sshd_config"
fi


unset -f safe_source


# added by travis gem
[ -f "${HOME}/.travis/travis.sh" ] && source "${HOME}/.travis/travis.sh"


# end empty line
echo ""
