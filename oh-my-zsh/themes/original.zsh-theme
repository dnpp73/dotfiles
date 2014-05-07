# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname
}

function prompt_char {
    if [ $UID -eq 0 ]; then
        echo "%{$terminfo[bold]$fg[red]%}#%{$reset_color%}";
    else
        echo "%{$terminfo[bold]$fg[magenta]%}$%{$reset_color%}";
    fi
}

function rbenv_version {
  rbenv version 2>/dev/null | awk '{print $1}'
}

# Directory info.
local current_dir='${PWD/#$HOME/~}'

# Git info.
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$reset_color%}[git:%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})]"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}(%{$fg[red]%}x"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}(%{$fg[green]%}o"

# Prompt format
PROMPT="\
%{$terminfo[bold]$fg[yellow]%}%n%{$reset_color%}\
%{$fg[yellow]%}@%{$reset_color%}\
%{$terminfo[bold]$fg[yellow]%}$(box_name)%{$reset_color%}\
 \
%{$terminfo[bold]$fg[white]%}${current_dir}%{$reset_color%}\
 \
%{$reset_color$fg[cyan]%}%D %*\
\
%{$reset_color%} -zsh \
$ZSH_VERSION\
\
${git_info} \
\
%{$fg[white]%}[rbenv:\
%{$fg[blue]%}$(rbenv_version)\
%{$fg[white]%}] \
\

%h \
$(prompt_char) "
