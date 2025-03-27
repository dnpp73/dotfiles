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
if [ -n "${GOENV_ROOT}" ] && [ -d "${GOENV_ROOT}" ]; then
    goenv_root="${GOENV_ROOT}"
elif [ -s "${HOME}/.goenv" ]; then
    goenv_root="${HOME}/.goenv"
elif [ -s '/opt/homebrew/var/goenv' ]; then
    goenv_root='/opt/homebrew/var/goenv'
elif [ -s '/opt/homebrew/opt/goenv' ]; then
    goenv_root='/opt/homebrew/opt/goenv'
elif [ -s '/usr/local/var/goenv' ]; then
    goenv_root='/usr/local/var/goenv'
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
if [ -n "${NODENV_ROOT}" ] && [ -d "${NODENV_ROOT}" ]; then
    nodenv_root="${NODENV_ROOT}"
elif [ -s "${HOME}/.nodenv" ]; then
    nodenv_root="${HOME}/.nodenv"
elif [ -s '/opt/homebrew/var/nodenv' ]; then
    nodenv_root='/opt/homebrew/var/nodenv'
elif [ -s '/opt/homebrew/opt/nodenv' ]; then
    nodenv_root='/opt/homebrew/opt/nodenv'
elif [ -s '/usr/local/var/nodenv' ]; then
    nodenv_root='/usr/local/var/nodenv'
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
if [ -n "${RBENV_ROOT}" ] && [ -d "${RBENV_ROOT}" ]; then
    rbenv_root="${RBENV_ROOT}"
elif [ -s "${HOME}/.rbenv" ]; then
    rbenv_root="${HOME}/.rbenv"
elif [ -s '/opt/homebrew/var/rbenv' ]; then
    rbenv_root='/opt/homebrew/var/rbenv'
elif [ -s '/opt/homebrew/opt/rbenv' ]; then
    rbenv_root='/opt/homebrew/opt/rbenv'
elif [ -s '/usr/local/var/rbenv' ]; then
    rbenv_root='/usr/local/var/rbenv'
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

# pyenv
if [ -n "${PYENV_ROOT}" ] && [ -d "${PYENV_ROOT}" ]; then
    pyenv_root="${PYENV_ROOT}"
elif [ -s "${HOME}/.pyenv" ]; then
    pyenv_root="${HOME}/.pyenv"
elif [ -s '/opt/homebrew/var/pyenv' ]; then
    pyenv_root='/opt/homebrew/var/pyenv'
elif [ -s '/opt/homebrew/opt/pyenv' ]; then
    pyenv_root='/opt/homebrew/opt/pyenv'
elif [ -s '/usr/local/var/pyenv' ]; then
    pyenv_root='/usr/local/var/pyenv'
elif [ -s '/usr/local/opt/pyenv' ]; then
    pyenv_root='/usr/local/opt/pyenv'
fi
if [ -n "${pyenv_root}" ]; then
    if which pyenv >/dev/null 2>&1; then
        export PYENV_ROOT="${pyenv_root}"
        echo -n 'pyenv '
        # eval "$(pyenv init --path)" # pyenv init - に含まれる。 --path だと補完や shell function まではやらないらしい。
        eval "$(pyenv init -)"
        # echo -n 'virtualenv '
        # eval "$(pyenv virtualenv-init -)"
    fi
fi

# rust rustup
if [ -n "${RUSTUP_HOME}" ] && [ -d "${RUSTUP_HOME}" ]; then
    rustup_root="${RUSTUP_HOME}"
elif [ -d "${HOME}/.rustup" ]; then
    rustup_root="${HOME}/.rustup"
fi
if [ -n "${rustup_root}" ]; then
    if which rustup >/dev/null 2>&1; then
        echo -n 'rustup '
        export RUSTUP_HOME="${rustup_root}"
    fi
fi

# rust cargo
if [ -n "${CARGO_HOME}" ] && [ -d "${CARGO_HOME}" ]; then
    cargo_root="${CARGO_HOME}"
elif [ -s "${HOME}/.cargo" ]; then
    cargo_root="${HOME}/.cargo"
fi
if [ -n "${cargo_root}" ]; then
    if which cargo >/dev/null 2>&1; then
        echo -n 'cargo '
        export CARGO_HOME="${cargo_root}"
        if [ -f "${cargo_root}/env" ]; then
            source "${cargo_root}/env"
        fi
    fi
fi

# oh-my-zsh
ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME='original'

# CASE_SENSITIVE='true'
DISABLE_AUTO_TITLE='true'
DISABLE_CORRECTION='true'
DISABLE_AUTO_UPDATE='true'
COMPLETION_WAITING_DOTS='false'

# Uncomment following line if you want to disable marking untracked files under VCS as dirty. This makes repository status check for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(emoji man)
if [ "${UNAME}" = 'Darwin' ]; then
    plugins+=(macos)
    if which xcodebuild >/dev/null 2>&1; then
        plugins+=(xcode)
    fi
    if which brew >/dev/null 2>&1; then
        plugins+=(brew)
    fi
elif [ "${UNAME}" = 'Linux' ]; then
    if [ -f '/etc/os-release' ]; then
        if grep -q '^ID=ubuntu' '/etc/os-release'; then
            plugins+=(ubuntu)
        fi
        if grep -q '^ID=debian' '/etc/os-release'; then
            plugins+=(debian)
        fi
    fi
fi
if which docker >/dev/null 2>&1; then
    plugins+=(docker)
    plugins+=(docker-compose)
    # # いつの間にかこれでも動かなくなってしまったので、後段で `source <(docker completion zsh)` することにした。
    # # https://github.com/ohmyzsh/ohmyzsh/issues/11789
    # zstyle ':completion:*:*:docker:*' option-stacking yes
    # zstyle ':completion:*:*:docker-*:*' option-stacking yes
    # zstyle ':omz:plugins:docker' legacy-completion yes
fi
if which git >/dev/null 2>&1; then
    plugins+=(git)
fi
if which node >/dev/null 2>&1; then
    plugins+=(node)
fi
if which npm >/dev/null 2>&1; then
    plugins+=(npm)
fi
if which yarn >/dev/null 2>&1; then
    plugins+=(yarn)
fi
if which ruby >/dev/null 2>&1; then
    plugins+=(ruby)
fi
if which gem >/dev/null 2>&1; then
    plugins+=(gem)
fi
if which bundle >/dev/null 2>&1; then
    plugins+=(bundler)
fi
if which python >/dev/null 2>&1 || which python3 >/dev/null 2>&1; then
    plugins+=(python)
fi
if which pip >/dev/null 2>&1 || which pip3 >/dev/null 2>&1; then
    plugins+=(pip)
fi
if which composer >/dev/null 2>&1; then
    plugins+=(composer)
fi
if which cargo >/dev/null 2>&1 || which rustc >/dev/null 2>&1 || which rustup >/dev/null 2>&1; then
    plugins+=(rust)
fi
if which redis-cli >/dev/null 2>&1; then
    plugins+=(redis-cli)
fi
if which aws >/dev/null 2>&1; then
    SHOW_AWS_PROMPT=false
    plugins+=(aws)
fi
if which gcloud >/dev/null 2>&1; then
    plugins+=(gcloud)
fi
if which terraform >/dev/null 2>&1; then
    plugins+=(terraform)
fi
if which flutter >/dev/null 2>&1; then
    plugins+=(flutter)
fi
if [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    plugins+=(zsh-autosuggestions)
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion) # 補完の方を履歴より優先度高めにする場合は順序を変える。
    ZSH_AUTOSUGGEST_HISTORY_IGNORE="(cd .*|l|ls|l *|ls *|code *|xed *)"
    ZSH_AUTOSUGGEST_COMPLETION_IGNORE="(l|ls|l *|ls *)"
fi
if [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    plugins+=(zsh-syntax-highlighting)
fi

# cmd + ← と cmd + → は iTerm2 側で 0x01 と 0x05 に設定している。他にも結構色々弄ってるかも…。
bindkey '^[^[[C' forward-word       # iTerm2 Custom Key Bindings, Opt + ← to 0x1b 0x1b 0x5b 0x44
bindkey '^[^[[D' backward-word      # iTerm2 Custom Key Bindings, Opt + → to 0x1b 0x1b 0x5b 0x43
bindkey '^[[H'   beginning-of-line  # fn + ←
bindkey '^[[F'   end-of-line        # fn + →
bindkey '^[^?'   backward-kill-word # Option + delete, Option as Meta key. 0x1b: esc, 0x7f: delete
bindkey '^U'     backward-kill-line # C-u, default: kill-whole-line. iTerm2 Custom Key Bindings, Cmd + delete to 0x15 (C-u)

# history 関連
export HISTFILE="${HISTRY_DIRECTORY}/zsh_history" # fc -AI でメモリからファイルに書き込むときに、 .zsh_history.new から mv みたいな挙動になってコンテナで使うときに面倒なのでディレクトリごと分けてる。
export HISTSIZE=5000   # メモリに保存される履歴の件数
export SAVEHIST=100000 # 履歴ファイルに保存される履歴の件数
export HISTORY_IGNORE="(cd|cd -|cd .*|cd /*|cd [[:alnum:]]*|cd _*|pwd|l|l *|l[sal]|l[sal] *|cp *|mv *|rm *|ln *|mkdir *|sudo cp *|sudo mv *|sudo rm *|sudo ln *|sudo mkdir *|xed *|code *|vim .*|vim _*|vim [[:alnum:]]*|git st|git ft|git pull|git lga|git df|git ci -m *|git br *|git add *|git ad|kill *|clear|exit)" # 履歴に残さないコマンド。 l, ls, la, ll は履歴に残さない。
setopt share_history             # 各端末で履歴(ファイル)を共有する = 履歴ファイルに対して参照と書き込みを行う。 書き込みは 時刻(タイムスタンプ) 付き。
setopt inc_append_history        # 履歴リストにイベントを登録するのと同時に、履歴ファイルにも書き込みを行う(追加する)。
setopt inc_append_history_time   # コマンド終了時に、履歴ファイルに書き込む。 .zsh_history をコンテナに共有すると相性が悪い。
setopt append_history            # zsh のセッション終了時に、履歴ファイルを上書きするのではなく追加する。デフォルトでもオンのはず。
setopt extended_history          # 開始と終了を記録
setopt hist_expire_dups_first    # 履歴リストのイベント数が上限(HISTSIZE)に達したときに、古いものではなく重複したイベントを削除する
setopt hist_find_no_dups         # ラインエディタでヒストリ検索するときに、一度見つかったものは後続で表示しない。
setopt hist_ignore_dups          # 入力したコマンドが、直前のものと同じなら履歴リストに追加しない。 hist_ignore_all_dups が ON なら要らない気もする。
setopt hist_ignore_all_dups      # 履歴リスト登録時に、すでに同じものがあったら削除する。
setopt hist_reduce_blanks        # 余分な空白は詰めて記録
# setopt hist_expand             # 補完時にヒストリを自動的に展開
setopt hist_ignore_space         # スペースで始まるコマンド行はヒストリリストから削除
setopt hist_verify               # ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_save_no_dups         # 古いコマンドと同じものは無視
setopt hist_no_store             # history, fc -l コマンドは履歴に登録しない
setopt hist_fcntl_lock           # ヒストリファイルをロックする

# https://qiita.com/sho-t/items/d44bfbc783db7ca278c0
zshaddhistory() {
    emulate -L zsh
    # ${1} に改行文字が複数含まれていたら return 1 する。改行で確定させるので 1 行だけ打てば普通は 2 になる。
    if [ "$(echo "${1}" | wc -l)" -ne 2 ]; then
        return 1
    fi
    if [[ ${1%%$'\n'} == ${~HISTORY_IGNORE} ]]; then
        return 1
    fi
}

# completion
if [ -d '/opt/homebrew/share/zsh/site-functions' ]; then
    fpath=('/opt/homebrew/share/zsh/site-functions' ${fpath})
    # fpath+=(/opt/homebrew/share/zsh/site-functions)
fi
if [ -d '/usr/local/share/zsh/site-functions' ]; then
    fpath=('usr/local/share/zsh/site-functions' ${fpath})
    # fpath+=(/usr/local/share/zsh/site-functions)
fi
if [ -d '/opt/homebrew/share/zsh-completions' ]; then
    fpath=('/opt/homebrew/share/zsh-completions' ${fpath})
    # fpath+=(/opt/homebrew/share/zsh-completions)
fi
if [ -d '/usr/local/share/zsh-completions' ]; then
    fpath=('/usr/local/share/zsh-completions' ${fpath})
    # fpath+=(/usr/local/share/zsh-completions)
fi
if [ -d "${HOME}/.zsh/completion" ]; then
    fpath=("${HOME}/.zsh/completion" ${fpath})
    # fpath+=("${HOME}/.zsh/completion")
fi

# oh-my-zsh の plugins の配列に入れるだけで補完まで動くのは aws だけだったので自前でなんとかするしかなった…。
ZSH_COMPDUMP="${HOME}/.cache/zsh/zcompdump"
mkdir -p "$(dirname "${ZSH_COMPDUMP}")"
AWS_COMPLETER_PATH="$(which aws_completer)"
AWS_COMPLETER_EXISTS=$?
if [ "${AWS_COMPLETER_EXISTS}" -eq 0 ]; then
    autoload bashcompinit
    bashcompinit
fi
autoload -Uz compinit
compinit -i -d "${ZSH_COMPDUMP}"
if [ "${AWS_COMPLETER_EXISTS}" -eq 0 ]; then
    complete -C "${AWS_COMPLETER_PATH}" aws
fi
unset AWS_COMPLETER_PATH
unset AWS_COMPLETER_EXISTS

echo -n 'oh-my-zsh '
source "${ZSH}/oh-my-zsh.sh"

# dart cli
if [ -f "${HOME}/.dart-cli-completion/zsh-config.zsh" ]; then
    source "${HOME}/.dart-cli-completion/zsh-config.zsh"
fi

# alias
unalias -m '*'

# common alias
safe_source "${ORG_DIR}/common_sh_alias" 'alias'

# Mac or Ubuntu alias
#if [ "${UNAME}" = 'Darwin' ]; then
#    safe_source "${ORG_DIR}/common_sh_alias_osx"
#elif [ "${UNAME}" = 'Linux' ]; then
#    safe_source "${ORG_DIR}/common_sh_alias_ubuntu"
#fi

# MAN を bat でオシャレに見る。
if which bat >/dev/null 2>&1; then
    alias bathelp='bat --plain --language=help' # これで cur --help all | bathelp くらいがほど良い。
    # alias -g -- -h='-h 2>&1 | bat --language=help --style=plain' # これはやりすぎ。
    # alias -g -- --help='--help 2>&1 | bat --language=help --style=plain' # これも curl とかだと --help all で潰れるのでやりすぎ。
elif which batcat >/dev/null 2>&1; then
    alias bathelp='batcat --plain --language=help'
fi

# ssh-agent について、あればそのまま使って、かつ、 screen 先でも困らないようにするやつ。 ssh 接続先では読まないようにする。
if [ -z "${SSH_CONNECTION}" ] && [ -z "${SSH_CLIENT}" ] && [ -z "${SSH_TTY}" ]; then
    safe_source "${ORG_DIR}/env_ssh_auth_sock" 'ssh_sock'
fi

# Mac iTerm2 Shell Integration
if [ "${UNAME}" = 'Darwin' ]; then
    safe_source "${HOME}/.iterm2_shell_integration.zsh" 'iterm2'
fi

# chpwd and auto venv activation
safe_source "${ORG_DIR}/zsh_chpwd" 'chpwd'
if which automate-python-venv-activation >/dev/null 2>&1; then
    automate-python-venv-activation >/dev/null 2>&1
fi

# docker completion hack
if which docker >/dev/null 2>&1; then
    source <(docker completion zsh)
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
