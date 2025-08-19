# %{ ... %} で挟むと、その中の色設定はプロンプトの長さ計算に含まれない。
function color256 {
    echo -n "\e[38;5;${1}m"
}

function colorize {
    local color_name="${1}"
    local text="${2}"
    if [ ${color_name} = 'gray' ]; then
        echo -n "%{$(color256 250)%}${text}%{${reset_color}%}"
    else
        echo -n "%{${fg[${color_name}]}%}${text}%{${reset_color}%}"
    fi
}

function bold-colorize {
    local color_name="${1}"
    local text="${2}"
    echo -n "%{${terminfo[bold]}%}$(colorize ${color_name} ${text})"
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname
}

function prev_command_exit_flag {
    # 三項演算子のようなやつ。
    echo -n '%(?.'
    colorize 'green' '✔'
    echo -n '.'
    colorize 'red' '✘'
    echo -n ')%'
}

function prompt_char {
    if [ "${UID}" -eq 0 ]; then
        bold-colorize 'red' '#'
    else
        bold-colorize 'magenta' '$'
    fi
}

function machine_name {
    if [ "$(uname)" = 'Darwin' ]; then
        local machine_color='yellow'
    elif [ "$(uname)" = 'Linux' ]; then
        local machine_color='green'
    fi

    bold-colorize ${machine_color} '%n'
    colorize      ${machine_color} '@'
    bold-colorize ${machine_color} "$(box_name)"
}

function __omz_custom_theme_anyenv_version {
    if which "${1}" >/dev/null 2>&1; then
        local result="$("${1}" version 2>/dev/null)"
        local version="$(echo "${result}" | cut -d ' ' -f1)"
        colorize 'gray' "${2}:"
        if [ "${version}" != 'system' ]; then
            if echo "${result}" | grep "$("${1}" root)" > /dev/null 2>&1; then
                colorize blue 'g'
                colorize gray ':'
            else
                colorize blue 'l'
                colorize gray ':'
            fi
        fi
        colorize 'cyan' "${version}"
        echo -n ' '
    fi
}

function __omz_custom_theme_rb_py_nod_go_env_info {
    local info=''
    info="${info}$(__omz_custom_theme_anyenv_version rbenv rb)"
    info="${info}$(__omz_custom_theme_anyenv_version pyenv py)"
    info="${info}$(__omz_custom_theme_anyenv_version nodenv node)"
    info="${info}$(__omz_custom_theme_anyenv_version goenv go)"
    # info から ' ' の後ろ 1 文字を削除する。
    info="${info% }"
    if [ "${info}" != '' ]; then
        colorize 'gray' '['
        echo -n "${info}"
        colorize 'gray' ']'
    fi
}

function __omz_custom_theme_venv_info {
    # VIRTUAL_ENV 環境変数があれば、その中身を表示する。
    if [ -n "${VIRTUAL_ENV}" ]; then
        local venv_dir="${VIRTUAL_ENV}"
        local venv_dirname="$(dirname "${venv_dir}")"
        local venv_relative_dirname="$(realpath --relative-to="${PWD}" "${venv_dirname}")"
        colorize 'gray' '[venv:'
        colorize 'cyan' "${venv_relative_dirname}"
        colorize 'gray' ']'
    fi
}

function __omz_custom_theme_ros_info {
    if [ -n "${ROS_DISTRO}" ]; then
        colorize 'gray' '[ROS:'
        colorize 'cyan' "${ROS_DISTRO}"
        colorize 'gray' ']'
    fi
}

function __omz_custom_theme_remove_ansi_escape {
    sed 's/\x1B\[[0-9;]*[a-zA-Z]//g'
}

function __omz_custom_theme_remove_zsh_escape {
    sed 's/%{%}//g'
}

# Directory info.
# 60 文字くらいで区切って [...] を間に入れて省略して表示する。最後のディレクトリ名は省略しない。
function __omz_custom_theme_shortened_pwd {
    local cols="$(tput cols)"
    local git_prompt_info_length="$(git_prompt_info | __omz_custom_theme_remove_ansi_escape | __omz_custom_theme_remove_zsh_escape | wc -m)"
    local venv_info_length="$(__omz_custom_theme_venv_info | __omz_custom_theme_remove_ansi_escape | __omz_custom_theme_remove_zsh_escape | wc -m)"
    local rb_py_nod_go_env_info_length="$(__omz_custom_theme_rb_py_nod_go_env_info | __omz_custom_theme_remove_ansi_escape | __omz_custom_theme_remove_zsh_escape | wc -m)"

    # ターミナルに表示する都合で、この文字数を超えたら省略する。
    # 'user@host [ここ] [git:master(✔)][venv:.][rbenv:g:3.2.2 pyenv:l:3.12.5]' みたいになって、 user@host と余裕を見て 25 文字くらい引いておく。
    local num_limit=$((cols - git_prompt_info_length - venv_info_length - rb_py_nod_go_env_info_length - 25))

    local num_truncation_str_length=5 # '[...]' の文字数

    local current_dir="${PWD/#${HOME}/~}"
    local current_dir_length=${#current_dir}
    if [ "${current_dir_length}" -le "$((num_limit + num_truncation_str_length))" ]; then
        bold-colorize 'white' "${current_dir}"
        return
    fi

    local current_dir_basename="$(basename "${current_dir}")"
    local basename_length=${#current_dir_basename}

    # '/'.length (1) + basename_length
    local num_minimum_suffix=$((1 + basename_length))

    # 凄い長いディレクトリ名にいるときは num_minimum_suffix が num_limit より大きくなるが、そういう場合は省略しない
    if [ "${num_minimum_suffix}" -gt "${num_limit}" ]; then
        colorize 'gray' '[...]'
        bold-colorize 'white' "/${current_dir_basename}"
        return
    fi

    # (num_limit - num_minimum_suffix) / 2 # 切り捨てられるので注意
    local num_prefix=$(((num_limit - num_minimum_suffix) / 2))
    local num_suffix=$((num_limit - num_prefix))
    bold-colorize 'white' "${current_dir[1,$num_prefix]}"
    colorize 'gray' '[...]'
    bold-colorize 'white' "${current_dir[-$num_suffix,-1]}"
}

# Git info.
ZSH_THEME_GIT_PROMPT_PREFIX="$(colorize 'gray' '[git:')%{${fg[magenta]}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$(colorize 'gray' ']')"
ZSH_THEME_GIT_PROMPT_DIRTY="$(colorize 'gray' '(')$(colorize 'red' '✘')$(colorize 'gray' ')')"
ZSH_THEME_GIT_PROMPT_CLEAN="$(colorize 'gray' '(')$(colorize 'green' '✔')$(colorize 'gray' ')')"

# Prompt format
PROMPT="\
$(machine_name) \$(__omz_custom_theme_shortened_pwd) \$(git_prompt_info)\$(__omz_custom_theme_venv_info)\$(__omz_custom_theme_rb_py_nod_go_env_info)\$(__omz_custom_theme_ros_info)
%h $(prev_command_exit_flag)  $(prompt_char) \
"

unfunction box_name
unfunction prev_command_exit_flag
unfunction prompt_char
unfunction machine_name
