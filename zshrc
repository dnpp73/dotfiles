# If not running interactively, don't do anything
[ -z "${PS1}" ] && return

# constants
ZSHRC_PATH="${HOME}/.zshrc"
C_DIR=$(
    cd "$(dirname "${ZSHRC_PATH}")" || exit 1
    pwd
)
ORG_DIR="${C_DIR}"
[ -L "${ZSHRC_PATH}" ] && ORG_DIR=$(
    cd "$(dirname "$(readlink "${ZSHRC_PATH}")")" || exit 1
    pwd
)
COLOR_GREEN_BOLD='\033[1;32m'
COLOR_RED_BOLD='\033[1;31m'
COLOR_OFF='\033[0m'

UNAME="$(uname)"

function safe_source() {
    if [ -s "$1" ]; then
        if [ "$2" != '' ]; then
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
if which direnv >/dev/null 2>&1; then
    echo -n 'direnv '
    eval "$(direnv hook zsh)"
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
    if which goenv >/dev/null 2>&1; then
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
    if which nodenv >/dev/null 2>&1; then
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
    if which rbenv >/dev/null 2>&1; then
        echo -n 'rbenv '
        export RBENV_ROOT="${rbenv_root}"
        eval "$(rbenv init -)"
    fi
fi

# # pyenv
# if [ -s "${HOME}/.pyenv/bin" ]; then
#     pyenv_root="${HOME}/.pyenv"
# elif [ -s '/opt/homebrew/opt/pyenv' ]; then
#     pyenv_root='/opt/homebrew/opt/pyenv'
# elif [ -s '/usr/local/opt/pyenv' ]; then
#     pyenv_root='/usr/local/opt/pyenv'
# fi
# if [ -n "${pyenv_root}" ]; then
#     if which pyenv >/dev/null 2>&1; then
#         export PYENV_ROOT="${pyenv_root}"
#         echo -n 'pyenv '
#         eval "$(pyenv init --path)"
#         eval "$(pyenv init -)"
#         echo -n 'virtualenv '
#         eval "$(pyenv virtualenv-init -)"
#     fi
# fi

# oh-my-zsh
ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME='original'

# CASE_SENSITIVE='true'
DISABLE_AUTO_TITLE='true'
DISABLE_CORRECTION='true'
DISABLE_AUTO_UPDATE='true'
COMPLETION_WAITING_DOTS='false'

# Uncomment following line if you want to disable marking untracked files under VCS as dirty. This makes repository status check for large repositories much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

if [ "${UNAME}" = 'Darwin' ]; then
    plugins=(macos)
elif [ "${UNAME}" = 'Linux' ]; then
    plugins=(ubuntu)
fi

# completion
if [ "${UNAME}" = 'Darwin' ]; then
    if [ -d '/opt/homebrew/share/zsh-completions' ]; then
        fpath=('/opt/homebrew/share/zsh-completions' ${fpath})
    fi
    if [ -d '/usr/local/share/zsh-completions' ]; then
        fpath=('/usr/local/share/zsh-completions' ${fpath})
    fi
    if [ -d "${HOME}/.zsh/completion" ]; then
        fpath=("${HOME}/.zsh/completion" ${fpath})
    fi
fi

# どうしても docker 関連の補完が 2 回目の zsh の起動で失敗するので重くなるけど .zcompdump を毎回生成させるために消す。
find "${HOME}" -maxdepth 1 -name '.zcompdump*' -delete

# oh-my-zsh の plugins の配列に入れるだけで補完まで動くのは aws だけだったので自前でなんとかするしかなった…。
AWS_COMPLETER_PATH="$(which aws_completer)"
AWS_COMPLETER_EXISTS=$?
if [ "${AWS_COMPLETER_EXISTS}" -eq 0 ]; then
    autoload bashcompinit
    bashcompinit
fi
autoload -Uz compinit
compinit -i
if [ "${AWS_COMPLETER_EXISTS}" -eq 0 ]; then
    complete -C "${AWS_COMPLETER_PATH}" aws
fi
unset AWS_COMPLETER_PATH
unset AWS_COMPLETER_EXISTS

echo -n 'oh-my-zsh '
source "${ZSH}/oh-my-zsh.sh"

# alias
unalias -m '*'

# common alias
safe_source "${ORG_DIR}/common_sh_alias" 'alias'

# Mac or Ubuntu alias
if [ "${UNAME}" = 'Darwin' ]; then
    safe_source "${ORG_DIR}/common_sh_alias_osx"
elif [ "${UNAME}" = 'Linux' ]; then
    safe_source "${ORG_DIR}/common_sh_alias_ubuntu"
fi

# ssh-agent について、あればそのまま使って、かつ、 screen 先でも困らないようにするやつ。 ssh 接続先では読まないようにする。
if [ -z "${SSH_CONNECTION}" ] && [ -z "${SSH_CLIENT}" ] && [ -z "${SSH_TTY}" ]; then
    safe_source "${ORG_DIR}/env_ssh_auth_sock" 'ssh_sock'
fi

# Mac iTerm2 Shell Integration
if [ "${UNAME}" = 'Darwin' ]; then
    safe_source "${HOME}/.iterm2_shell_integration.zsh" 'iterm2'
fi

# 最後に local があれば
safe_source "${HOME}/.zshrc_local" 'zshrc_local'

# loading end line
echo ''

unset COLOR_GREEN_BOLD COLOR_RED_BOLD COLOR_OFF
unset -f safe_source

# Mac /etc/sshd_config check
if [ "${UNAME}" = 'Darwin' ]; then
    source "${ORG_DIR}/check_osx_sshd_config"
    source "${ORG_DIR}/check_osx_letsencrypt_config"
fi
