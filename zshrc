# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# constants
ZSHRC_PATH="$HOME/.zshrc"
C_DIR=$(cd $(dirname "$ZSHRC_PATH") && pwd)
ORG_DIR="$C_DIR"
[ -L "$ZSHRC_PATH" ] && ORG_DIR=$(cd $(dirname $(readlink "$ZSHRC_PATH")) && pwd)
COLOR_GREEN_BOLD='\033[1;32m'
COLOR_RED_BOLD='\033[1;31m'
COLOR_OFF='\033[0m'


function safe_source() {
    if [ -s "$1" ]; then
        if [ "$2" != "" ]; then
            echo -n "$2 "
        fi
        . "$1"
    fi
}


# loading start line
echo -n "...loading "


# common
safe_source "${ORG_DIR}/common_shrc" "shrc"


# direnv
if which direnv > /dev/null 2>&1; then
    echo -n "direnv "
    eval "$(direnv hook zsh)"
fi


# nodenv
if [ -s "${HOME}/.nodenv/bin" ]; then
    nodenv_root="${HOME}/.nodenv"
elif [ -s "/usr/local/nodenv" ]; then
    nodenv_root="/usr/local/nodenv"
elif [ -s "/usr/local/opt/nodenv" ]; then
    nodenv_root="/usr/local/opt/nodenv"
fi
if [ -n "$nodenv_root" ]; then
    if which nodenv > /dev/null 2>&1; then
        echo -n "nodenv "
        export NODENV_ROOT="$nodenv_root"
        eval "$(nodenv init -)"
    fi
fi


# rbenv
if [ -s "${HOME}/.rbenv/bin" ]; then
    rbenv_root="${HOME}/.rbenv"
elif [ -s "/usr/local/rbenv" ]; then
    rbenv_root="/usr/local/rbenv"
elif [ -s "/usr/local/opt/rbenv" ]; then
    rbenv_root="/usr/local/opt/rbenv"
fi
if [ -n "$rbenv_root" ]; then
    if which rbenv > /dev/null 2>&1; then
        echo -n "rbenv "
        export RBENV_ROOT="$rbenv_root"
        eval "$(rbenv init -)"
    fi
fi


# pyenv
if [ -s "${HOME}/.pyenv/bin" ]; then
    pyenv_root="${HOME}/.pyenv"
elif [ -s "/usr/local/pyenv" ]; then
    pyenv_root="/usr/local/pyenv"
elif [ -s "/usr/local/opt/pyenv" ]; then
    pyenv_root="/usr/local/opt/pyenv"
fi
if [ -n "$pyenv_root" ]; then
    if which pyenv > /dev/null 2>&1; then
        export PYENV_ROOT="$pyenv_root"
        echo -n "pyenv "
        eval "$(pyenv init -)";
        echo -n "virtualenv "
        eval "$(pyenv virtualenv-init -)";
    fi
fi


# oh-my-zsh
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="original"

# CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"
DISABLE_CORRECTION="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="false"

# Uncomment following line if you want to disable marking untracked files under VCS as dirty. This makes repository status check for large repositories much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

if [ `uname` = "Darwin" ]; then
    # plugins=(osx terminalapp autojump screen sudo brew git git-extras ruby bundler gem rake rbenv pod vagrant docker docker-compose pyenv virtualenv pip)
    plugins=(osx brew bundler gem pip node npm aws)
elif [ `uname` = "Linux" ]; then
    # plugins=(ubuntu autojump screen sudo git git-extras ruby bundler gem rake rbenv pyenv virtualenv pip)
    plugins=(ubuntu)
fi

echo -n "oh-my-zsh "
source $ZSH/oh-my-zsh.sh


# homebrew が勝手に追記したやつ
fpath=(/usr/local/share/zsh-completions $fpath)


# Google Cloud SDK
safe_source "${HOME}/google-cloud-sdk/path.zsh.inc" "google-cloud-sdk"
safe_source "${HOME}/google-cloud-sdk/completion.zsh.inc"


# alias
unalias -m '*'


# common alias
safe_source "${ORG_DIR}/common_sh_alias" "alias"


# Mac or Ubuntu alias
if [ `uname` = "Darwin" ]; then
    safe_source "${ORG_DIR}/common_sh_alias_osx"
elif [ `uname` = "Linux" ]; then
    safe_source "${ORG_DIR}/common_sh_alias_ubuntu"
fi


# ssh-agent について、あればそのまま使って、かつ、 screen 先でも困らないようにするやつ。 ssh 接続先では読まないようにする。
if [ -z "$SSH_CONNECTION" -a -z "$SSH_CLIENT" -a -z "$SSH_TTY" ]; then
    safe_source "${ORG_DIR}/env_ssh_auth_sock" "ssh_sock"
fi


# Mac iTerm2 Shell Integration
if [ `uname` = "Darwin" ]; then
    safe_source "${HOME}/.iterm2_shell_integration.zsh" "iterm2"
fi


# 最後に local があれば
safe_source "${HOME}/.zshrc_local" "zshrc_local"


# loading end line
echo ""


unset COLOR_GREEN_BOLD COLOR_RED_BOLD COLOR_OFF
unset -f safe_source


# Mac /etc/sshd_config check
if [ `uname` = "Darwin" ]; then
    source "$ORG_DIR/check_osx_sshd_config"
fi
