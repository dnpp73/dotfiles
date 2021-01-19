# If not running interactively, don't do anything
[ -z "${PS1}" ] && return


# constants
C_DIR=$(cd "$(dirname "${BASH_SOURCE}")" || exit 1; pwd)
ORG_DIR="${C_DIR}"
[ -L "${BASH_SOURCE}" ] && ORG_DIR=$(cd "$(dirname "$(readlink "${BASH_SOURCE}")")" || exit 1; pwd)
COLOR_GREEN_BOLD='\033[1;32m'
COLOR_RED_BOLD='\033[1;31m'
COLOR_OFF='\033[0m'


function safe_source() {
    if [ -s "$1" ]; then
        if [ "$2" != "" ]; then
            echo -n "$2 "
        fi
        source "$1"
    fi
}


# loading start line
echo -n '...loading '


# common
safe_source "${ORG_DIR}/common_shrc" 'shrc'


# direnv
if which direnv > /dev/null 2>&1; then
    echo -n 'direnv '
    eval "$(direnv hook bash)"
fi


# goenv
if [ -s "${HOME}/.goenv/bin" ]; then
    goenv_root="${HOME}/.goenv"
elif [ -s '/opt/homebrew/opt/goenv' ]; then
    goenv_root='/opt/homebrew/opt/goenv'
elif [ -s '/usr/local/opt/goenv' ]; then
    goenv_root='/usr/local/opt/goenv'
fi
if [ -n "${goenv_root}" ]; then
    if which goenv > /dev/null 2>&1; then
        echo -n 'goenv '
        export GOENV_ROOT="${goenv_root}"
        eval "$(goenv init -)"
    fi
fi


# nodenv
if [ -s "${HOME}/.nodenv/bin" ]; then
    nodenv_root="${HOME}/.nodenv"
elif [ -s '/opt/homebrew/opt/nodenv' ]; then
    nodenv_root='/opt/homebrew/opt/nodenv'
elif [ -s '/usr/local/opt/nodenv' ]; then
    nodenv_root='/usr/local/opt/nodenv'
fi
if [ -n "${nodenv_root}" ]; then
    if which nodenv > /dev/null 2>&1; then
        echo -n 'nodenv '
        export NODENV_ROOT="${nodenv_root}"
        eval "$(nodenv init -)"
    fi
fi


# rbenv
if [ -s "${HOME}/.rbenv/bin" ]; then
    rbenv_root="${HOME}/.rbenv"
elif [ -s '/opt/homebrew/opt/rbenv' ]; then
    rbenv_root='/opt/homebrew/opt/rbenv'
elif [ -s '/usr/local/opt/rbenv' ]; then
    rbenv_root='/usr/local/opt/rbenv'
fi
if [ -n "${rbenv_root}" ]; then
    if which rbenv > /dev/null 2>&1; then
        echo -n 'rbenv '
        export RBENV_ROOT="${rbenv_root}"
        eval "$(rbenv init -)"
    fi
fi


# pyenv
if [ -s "${HOME}/.pyenv/bin" ]; then
    pyenv_root="${HOME}/.pyenv"
elif [ -s '/opt/homebrew/opt/pyenv' ]; then
    pyenv_root='/opt/homebrew/opt/pyenv'
elif [ -s '/usr/local/opt/pyenv' ]; then
    pyenv_root='/usr/local/opt/pyenv'
fi
if [ -n "${pyenv_root}" ]; then
    if which pyenv > /dev/null 2>&1; then
        export PYENV_ROOT="${pyenv_root}"
        echo -n 'pyenv '
        eval "$(pyenv init -)";
        echo -n 'virtualenv '
        eval "$(pyenv virtualenv-init -)";
    fi
fi


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


# bash_completion
if [ -s '/opt/homebrew/etc/bash_completion' ]; then
    echo -n 'bash_completion '
    source '/opt/homebrew/etc/bash_completion'
elif [ -s '/usr/local/etc/bash_completion' ]; then
    echo -n 'bash_completion '
    source '/usr/local/etc/bash_completion'
elif [ -s '/etc/bash_completion' ]; then
    echo -n 'bash_completion '
    source '/etc/bash_completion'
fi


if [ $(uname) = 'Darwin' ]; then
    # homebrew で入れた curl-ca-bundle
    [ -r '/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt' ] && export SSL_CERT_FILE='/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt'
    [ -r '/opt/homebrew/opt/curl-ca-bundle/share/ca-bundle.crt' ] && export SSL_CERT_FILE='/opt/homebrew/opt/curl-ca-bundle/share/ca-bundle.crt'
fi


# Google Cloud SDK
safe_source "${HOME}/google-cloud-sdk/path.bash.inc" 'google-cloud-sdk'
safe_source "${HOME}/google-cloud-sdk/completion.bash.inc"


# Mac or Ubuntu PS1
safe_source "${ORG_DIR}/bash_prompt" 'bash_prompt'


# alias
unalias -a

# common alias
safe_source "${ORG_DIR}/common_sh_alias" 'alias'

# Mac or Ubuntu alias
if [ $(uname) = 'Darwin' ]; then
    safe_source "${ORG_DIR}/common_sh_alias_osx"
elif [ $(uname) = 'Linux' ]; then
    safe_source "${ORG_DIR}/common_sh_alias_ubuntu"
fi


# ssh-agent について、あればそのまま使って、かつ、 screen 先でも困らないようにするやつ。 ssh 接続先では読まないようにする。
if [ -z "${SSH_CONNECTION}" -a -z "${SSH_CLIENT}" -a -z "${SSH_TTY}" ]; then
    safe_source "${ORG_DIR}/env_ssh_auth_sock" 'ssh_sock'
fi


# 最後に local があれば
safe_source "${HOME}/.bashrc_local" 'bashrc_local'


# loading end line
echo ''


unset COLOR_GREEN_BOLD COLOR_RED_BOLD COLOR_OFF
unset -f safe_source


# Mac /etc/sshd_config check
if [ $(uname) = 'Darwin' ]; then
    source "${ORG_DIR}/check_osx_sshd_config"
fi
