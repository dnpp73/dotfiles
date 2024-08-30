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
        local venv_dir="${VIRTUAL_ENV}"
        local venv_dirname="$(dirname "${venv_dir}")"
        local venv_relative_dirname="$(realpath --relative-to="${PWD}" "${venv_dirname}")"
        echo -n "${fg_gray}[venv:${fg[cyan]}${venv_relative_dirname}${fg_gray}]${reset_color} "
    fi
}

# Directory info.
# local current_dir='${PWD/#${HOME}/~}' # $HOME を ~ に置き換えるだけのパターン
# local current_dir='$(basename "${PWD/#${HOME}/~}")' # basename で最後のディレクトリ名だけにするパターン
# 60 文字くらいで区切って [...] を間に入れて省略して表示する。最後のディレクトリ名は省略しない。
function __omz_shortened_pwd {
    local num_limit=60 # ターミナルに表示する都合で、この文字数を超えたら省略する
    local num_truncation_str_length=5 # '[...]' の文字数

    local current_dir="${PWD/#${HOME}/~}"
    local current_dir_length=${#current_dir}
    if [ "${current_dir_length}" -le "$((num_limit + num_truncation_str_length))" ]; then
        echo -n "${current_dir}"
        return
    fi

    local current_dir_basename="$(basename "${current_dir}")"
    local basename_length=${#current_dir_basename}

    # '/'.length (1) + basename_length
    local num_minimum_suffix=$((1 + basename_length))

    # 凄い長いディレクトリ名にいるときは num_minimum_suffix が num_limit より大きくなるが、そういう場合は省略しない
    if [ "${num_minimum_suffix}" -gt "${num_limit}" ]; then
        echo -n "${fg_gray}[...]${terminfo[bold]}${fg[white]}/${current_dir_basename}"
        return
    fi

    # (num_limit - num_minimum_suffix) / 2 # 切り捨てられるので注意
    local num_prefix=$(((num_limit - num_minimum_suffix) / 2))
    local num_suffix=$((num_limit - num_prefix))
    echo -n "${current_dir[1,$num_prefix]}${reset_color}${fg_gray}[...]${terminfo[bold]}${fg[white]}${current_dir[-$num_suffix,-1]}"
}
local current_dir='$(__omz_shortened_pwd)'

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
${current_dir}${reset_color} \
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
