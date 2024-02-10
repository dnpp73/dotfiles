# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname
}

function prev_command_exit_flag {
    echo -n "%(?.%{$fg[green]%}✔.%{$fg[red]%}✘)%{$reset_color%}"
}

function prompt_char {
    if [ $UID -eq 0 ]; then
        echo -n "%{$terminfo[bold]$fg[red]%}#%{$reset_color%}";
    else
        echo -n "%{$terminfo[bold]$fg[magenta]%}$%{$reset_color%}";
    fi
}

function machine_name {
    if [ `uname` = "Darwin" ]; then
        machine_color="yellow"
    elif [ `uname` = "Linux" ]; then
        machine_color="green"
    fi

    echo -n "\
%{$terminfo[bold]$fg[$machine_color]%}%n%{$reset_color%}\
%{$fg[$machine_color]%}@%{$reset_color%}\
%{$terminfo[bold]$fg[$machine_color]%}$(box_name)%{$reset_color%}\
"
}

function rbenv_version {
    RBENV_RESULT=$(rbenv version 2>/dev/null)
    RBENV_VERSION=$(echo $RBENV_RESULT | cut -d ' ' -f1)
    if echo $RBENV_RESULT | grep $RBENV_ROOT > /dev/null 2>&1; then
        echo "%{$fg[cyan]%}$RBENV_VERSION%{$fg[blue]%}(g)%{$reset_color%}"
    else
        echo "%{$fg[cyan]%}$RBENV_VERSION%{$fg[blue]%}(l)%{$reset_color%}"
    fi
}

function pyenv_version {
    PYENV_RESULT=$(pyenv version 2>/dev/null)
    PYENV_VERSION=$(echo $PYENV_RESULT | cut -d ' ' -f1)
    if echo $PYENV_RESULT | grep $PYENV_ROOT > /dev/null 2>&1; then
        echo "%{$fg[cyan]%}$PYENV_VERSION%{$fg[blue]%}(g)%{$reset_color%}"
    else
        echo "%{$fg[cyan]%}$PYENV_VERSION%{$fg[blue]%}(l)%{$reset_color%}"
    fi
}

function nodenv_version {
    NODENV_RESULT=$(nodenv version 2>/dev/null)
    NODENV_VERSION=$(echo $NODENV_RESULT | cut -d ' ' -f1)
    if echo $NODENV_RESULT | grep $NODENV_ROOT > /dev/null 2>&1; then
        echo "%{$fg[cyan]%}$NODENV_VERSION%{$fg[blue]%}(g)%{$reset_color%}"
    else
        echo "%{$fg[cyan]%}$NODENV_VERSION%{$fg[blue]%}(l)%{$reset_color%}"
    fi
}

function goenv_version {
    GOENV_RESULT=$(goenv version 2>/dev/null)
    GOENV_VERSION=$(echo $GOENV_RESULT | cut -d ' ' -f1)
    if echo $GOENV_RESULT | grep $GOENV_ROOT > /dev/null 2>&1; then
        echo "%{$fg[cyan]%}$GOENV_VERSION%{$fg[blue]%}(g)%{$reset_color%}"
    else
        echo "%{$fg[cyan]%}$GOENV_VERSION%{$fg[blue]%}(l)%{$reset_color%}"
    fi
}

function rb_py_nod_go_env_info {
    local info='['
    if which rbenv >/dev/null 2>&1; then
        info="${info}rbenv: \$(rbenv_version), "
    fi
    if which pyenv >/dev/null 2>&1; then
        info="${info}pyenv: \$(pyenv_version), "
    fi
    if which nodenv >/dev/null 2>&1; then
        info="${info}nodenv: \$(nodenv_version), "
    fi
    if which goenv >/dev/null 2>&1; then
        info="${info}goenv: \$(goenv_version), "
    fi
    # info から ', ' の後ろ 2 文字を削除して、 ']' で見た目を閉じる。
    info="${info%, }"
    info="${info}]"
    if [ "${info}" = '[]' ]; then
        info=''
    fi
    echo -n "${info}"
}

# Directory info.
local current_dir='${PWD/#$HOME/~}'

# Git info.
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$reset_color%}[git:%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})]"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}(%{$fg[red]%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}(%{$fg[green]%}✔"


# Prompt format
# rbenv nodenv goenv の情報入りのやつ。
PROMPT="\
$(machine_name)\
 \
%{$terminfo[bold]$fg[white]%}\
${current_dir}\
 \
%{$reset_color$fg[cyan]%}\
%D %*\
\
%{$reset_color%}\
 -zsh $ZSH_VERSION\
\
${git_info} \
\
%{$fg[white]%}\
$(rb_py_nod_go_env_info)\
 \
\

%h \
$(prev_command_exit_flag) \
$(prompt_char) "
