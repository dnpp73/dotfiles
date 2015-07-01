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
    rbenv version 2>/dev/null | awk '{print $1}'
}

function pyenv_version {
    pyenv version 2>/dev/null | awk '{print $1}'
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
PROMPT="\
$(machine_name)\
 \
%{$terminfo[bold]$fg[white]%}${current_dir}%{$reset_color%}\
 \
%{$reset_color$fg[cyan]%}%D %*\
\
%{$reset_color%} -zsh $ZSH_VERSION\
\
${git_info} \
\
%{$fg[white]%}[rbenv:%{$fg[blue]%}$(rbenv_version)%{$fg[white]%}, pyenv:%{$fg[blue]%}$(pyenv_version)%{$fg[white]%}] \
\

%h \
$(prev_command_exit_flag) \
$(prompt_char) "
