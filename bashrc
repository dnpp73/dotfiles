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
C_DIR=$(cd $(dirname "$BASH_SOURCE") && pwd)
ORG_DIR="$C_DIR"
[ -L "$BASH_SOURCE" ] && ORG_DIR=$(cd $(dirname $(readlink "$BASH_SOURCE")) && pwd)


# start empty line
echo ""


# common
safe_source "${ORG_DIR}/common_shrc"


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
if [ -s /usr/local/etc/bash_completion ]; then
    echo ""
    echo "...loading bash_completion"
    source /usr/local/etc/bash_completion
    echo ""
elif [ -s /etc/bash_completion ]; then
    echo ""
    echo "...loading bash_completion"
    source /etc/bash_completion
    echo ""
fi


# Mac or Ubuntu bashrc
if [ `uname` = "Darwin" ]; then
    safe_source "$ORG_DIR/bashrc.osx"
elif [ `uname` = "Linux" ]; then
    safe_source "$ORG_DIR/bashrc.ubuntu"
fi


# alias
unalias -a

# common alias
safe_source "$ORG_DIR/common_sh_alias"

# Mac or Ubuntu alias
if [ `uname` = "Darwin" ]; then
    safe_source "$ORG_DIR/common_sh_alias_osx"
elif [ `uname` = "Linux" ]; then
    safe_source "$ORG_DIR/common_sh_alias_ubuntu"
fi


# ssh-agent について、あればそのまま使って、かつ、 screen 先でも困らないようにするやつ
if [ -s "${ORG_DIR}/env_ssh_auth_sock" ]; then
    safe_source "${ORG_DIR}/env_ssh_auth_sock"
fi


# 最後に local があれば
if [ -s "${HOME}/.bashrc_local" ]; then
    safe_source "${HOME}/.bashrc_local"
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
