local fg_gray="%{\e[38;5;250m%}"

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname
}

function prev_command_exit_flag {
    echo -n "%(?.%{${fg[green]}%}✔.%{${fg[red]}%}✘)%{${reset_color}%}"
}

function prompt_char {
    if [ "${UID}" -eq 0 ]; then
        echo -n "%{${terminfo[bold]}${fg[red]}%}#%{${reset_color}%}"
    else
        echo -n "%{${terminfo[bold]}${fg[magenta]}%}$%{${reset_color}%}"
    fi
}

function machine_name {
    if [ "$(uname)" = 'Darwin' ]; then
        machine_color='yellow'
    elif [ "$(uname)" = 'Linux' ]; then
        machine_color='green'
    fi

    echo -n "\
%{${terminfo[bold]}${fg[$machine_color]}%}%n%{${reset_color}%}\
%{${fg[${machine_color}]}%}@%{${reset_color}%}\
%{${terminfo[bold]}${fg[${machine_color}]}%}$(box_name)%{${reset_color}%}\
"
}

function __omz_custom_theme_rbenv_version {
    RBENV_RESULT="$(rbenv version 2>/dev/null)"
    RBENV_VERSION="$(echo "${RBENV_RESULT}" | cut -d ' ' -f1)"
    if [ "${RBENV_VERSION}" != 'system' ]; then
        if echo "${RBENV_RESULT}" | grep "${RBENV_ROOT}" > /dev/null 2>&1; then
            echo -n "%{${fg[blue]}%}g${fg_gray}:"
        else
            echo -n "%{${fg[blue]}%}l${fg_gray}:"
        fi
    fi
    echo -n "%{${fg[cyan]}%}${RBENV_VERSION}%{${reset_color}%}"
}

function __omz_custom_theme_pyenv_version {
    PYENV_RESULT="$(pyenv version 2>/dev/null)"
    PYENV_VERSION="$(echo "${PYENV_RESULT}" | cut -d ' ' -f1)"
    if [ "${PYENV_VERSION}" != 'system' ]; then
        if echo "${PYENV_RESULT}" | grep "${PYENV_ROOT}" > /dev/null 2>&1; then
            echo -n "%{${fg[blue]}%}g${fg_gray}:"
        else
            echo -n "%{${fg[blue]}%}l${fg_gray}:"
        fi
    fi
    echo -n "%{${fg[cyan]}%}${PYENV_VERSION}%{${reset_color}%}"
}

function __omz_custom_theme_nodenv_version {
    NODENV_RESULT="$(nodenv version 2>/dev/null)"
    NODENV_VERSION="$(echo "${NODENV_RESULT}" | cut -d ' ' -f1)"
    if [ "${NODENV_VERSION}" != 'system' ]; then
        if echo "${NODENV_RESULT}" | grep "${NODENV_ROOT}" > /dev/null 2>&1; then
            echo -n "%{${fg[blue]}%}g${fg_gray}:"
        else
            echo -n "%{${fg[blue]}%}l${fg_gray}:"
        fi
    fi
    echo -n "%{${fg[cyan]}%}${NODENV_VERSION}%{${reset_color}%}"
}

function __omz_custom_theme_goenv_version {
    GOENV_RESULT="$(goenv version 2>/dev/null)"
    GOENV_VERSION="$(echo ${GOENV_RESULT} | cut -d ' ' -f1)"
    if [ "${GOENV_VERSION}" != 'system' ]; then
        if echo "${GOENV_RESULT}" | grep "${GOENV_ROOT}" > /dev/null 2>&1; then
            echo -n "%{${fg[blue]}%}g${fg_gray}:"
        else
            echo -n "%{${fg[blue]}%}l${fg_gray}:"
        fi
    fi
    echo -n "%{${fg[cyan]}%}${GOENV_VERSION}%{${reset_color}%}"
}

function rb_py_nod_go_env_info {
    local info='['
    if which rbenv >/dev/null 2>&1; then
        info="${info}rbenv:\$(__omz_custom_theme_rbenv_version)${fg_gray}, "
    fi
    if which pyenv >/dev/null 2>&1; then
        info="${info}pyenv:\$(__omz_custom_theme_pyenv_version)${fg_gray}, "
    fi
    if which nodenv >/dev/null 2>&1; then
        info="${info}nodenv:\$(__omz_custom_theme_nodenv_version)${fg_gray}, "
    fi
    if which goenv >/dev/null 2>&1; then
        info="${info}goenv:\$(__omz_custom_theme_goenv_version)${fg_gray}, "
    fi
    # info から ',' の後ろ 1 文字を削除して、 ']' で見た目を閉じる。
    info="${info%, }"
    info="${info}]"
    if [ "${info}" != '[]' ]; then
        echo -n "%{${reset_color}%}${fg_gray}${info}%{${reset_color}%} "
    fi
}

function __omz_custom_theme_venv_info {
    # VIRTUAL_ENV 環境変数があれば、その中身を表示する。
    if [ -n "${VIRTUAL_ENV}" ]; then
        # 末尾が /.venv か /venv なら削除して、 $HOME は ~ に置換して、最後のディレクトリ名以外を 1 文字に省略する
        local venv_dir="${VIRTUAL_ENV}"
        venv_dir="${venv_dir/#${HOME}/~}"
        venv_dir="${venv_dir/%\/.venv/}"
        venv_dir="${venv_dir/%\/venv/}"
        local venv_basename="$(basename "${venv_dir}")"
        venv_dir="$(echo "${venv_dir}" | sed 's/\b\(\w\)\w*/\1/g')"
        echo -n "${fg_gray}[venv:${fg[cyan]}${venv_dir}/${venv_basename}${fg_gray}]${reset_color} "
    fi
}

# Directory info.
local current_dir='${PWD/#$HOME/~}'

# Git info.
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{${reset_color}%}${fg_gray}[git:%{${fg[magenta]}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${fg_gray})]%{${reset_color}%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{${reset_color}%}(%{${fg[red]}%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{${reset_color}%}(%{${fg[green]}%}✔"


# Prompt format
PROMPT="\
$(machine_name)\
\
%{${terminfo[bold]}${fg[white]}%} \
${current_dir} \
\
${git_info}\
\
\$(__omz_custom_theme_venv_info)\
\
$(rb_py_nod_go_env_info)\
\

%h \
$(prev_command_exit_flag) \
$(prompt_char) "

unfunction box_name
unfunction prev_command_exit_flag
unfunction prompt_char
unfunction machine_name
unfunction rb_py_nod_go_env_info
