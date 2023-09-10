#!/bin/bash

# constants
C_DIR=$(
    cd "$(dirname "$0")" || exit 1
    pwd
)
ORG_DIR="${C_DIR}"
[ -L "$0" ] && ORG_DIR=$(
    cd "$(dirname "$(readlink "$0")")" || exit 1
    pwd
)
NOW=$(date '+%Y%m%d%H%M%S')
BACKUP_SUFFIX="${NOW}bak"

#functions
function safe_create_symlink() {
    if [ -L "$2" ]; then
        echo " [$(basename "$0")] $(basename "$2") already exists symlink."
        exist_link_absolute_dir=$(
            cd "$(dirname "$(readlink "$2")")" || exit 1
            pwd
        )
        exist_link_basename=$(basename "$(readlink "$2")")
        exist_link_absolute_path="${exist_link_absolute_dir}/${exist_link_basename}"
        if [ "$1" = "${exist_link_absolute_path}" ]; then
            echo " [$(basename "$0")] $(basename "$2") is valid link."
            echo ""
            return
        else
            echo " [$(basename "$0")] mv $2 ${2}_${BACKUP_SUFFIX}"
            mv "$2" "${2}_${BACKUP_SUFFIX}"
        fi

    elif [ -d "$2" ]; then
        echo " [$(basename "$0")] $(basename "$2") already exists dir."
        echo " [$(basename "$0")] mv $2 ${2}_${BACKUP_SUFFIX}"
        mv "$2" "${2}_${BACKUP_SUFFIX}"

    elif [ -f "$2" ]; then
        echo " [$(basename "$0")] $(basename "$2") already exists file."
        echo " [$(basename "$0")] mv $2 ${2}_${BACKUP_SUFFIX}"
        mv "$2" "${2}_${BACKUP_SUFFIX}"

    fi

    echo " [$(basename "$0")] ln -s $1 $2"
    ln -s "$1" "$2"
    echo ""
}

function safe_cp() {
    if [ -L "$2" ]; then
        echo " [$(basename "$0")] $(basename "$2") already exists symlink."
        echo " [$(basename "$0")] mv $2 ${2}_${BACKUP_SUFFIX}"
        mv "$2" "${2}_${BACKUP_SUFFIX}"

    elif [ -d "$2" ]; then
        echo " [$(basename "$0")] $(basename "$2") already exists dir."
        echo " [$(basename "$0")] mv $2 ${2}_${BACKUP_SUFFIX}"
        mv "$2" "${2}_${BACKUP_SUFFIX}"

    elif [ -f "$2" ]; then
        echo " [$(basename "$0")] $(basename "$2") already exists file."
        if diff "$1" "$2" >/dev/null 2>&1; then
            echo " [$(basename "$0")] $(basename "$2") is same file."
            echo ""
            return
        else
            echo " [$(basename "$0")] mv $2 ${2}_${BACKUP_SUFFIX}"
            mv "$2" "${2}_${BACKUP_SUFFIX}"
        fi

    fi

    echo " [$(basename "$0")] cp $1 $2"
    cp "$1" "$2"
    echo ""
}

# git submodule (for vim bundle)
echo " [$(basename "$0")] --- install vim bundles ---"

echo " [$(basename "$0")] git submodule update --init"
cd "${ORG_DIR}" || exit 1
git submodule update --init
echo ""

# oh-my-zsh
echo " [$(basename "$0")] --- install oh-my-zsh ---"

if [ ! -d "${HOME}/.oh-my-zsh/.git" ]; then
    echo " [$(basename "$0")] git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh"
    cd "${HOME}" || exit 1
    git clone 'https://github.com/robbyrussell/oh-my-zsh.git' "${HOME}/.oh-my-zsh"
else
    echo " [$(basename "$0")] already exists oh-my-zsh"
fi

DOTFILES_DIR="${ORG_DIR}"
safe_cp "${DOTFILES_DIR}/oh-my-zsh/themes/original.zsh-theme" "${HOME}/.oh-my-zsh/custom/themes/original.zsh-theme"

# iTerm2 Shell Integration
if [ "$(uname)" = 'Darwin' ]; then
    echo " [$(basename "$0")] --- install iTerm2 Shell Integration for zsh ---"
    if [ ! -f "${HOME}/.iterm2_shell_integration.zsh" ]; then
        echo " [$(basename "$0")] curl -fsSL https://iterm2.com/misc/zsh_startup.in > ${HOME}/.iterm2_shell_integration.zsh"
        curl -L 'https://iterm2.com/misc/zsh_startup.in' >"${HOME}/.iterm2_shell_integration.zsh"
    else
        echo " [$(basename "$0")] already exists iTerm2 Shell Integration for zsh"
    fi
    echo ""
fi

# dotfiles
echo " [$(basename "$0")] --- install my dotfiles ---"

DOTFILES=(
    'bash_profile'
    'bashrc'
    'gitconfig'
    'gitignore_global'
    'inputrc'
    'vimrc'
    'vim'
    'gvimrc'
    'zshrc'
    'gemrc'
    'tmux.conf'
    'terraformrc'
)

for filename in "${DOTFILES[@]}"; do
    safe_create_symlink "${DOTFILES_DIR}/${filename}" "${HOME}/.${filename}"
done

# screenrc
if [ "$(uname)" = 'Darwin' ]; then
    safe_create_symlink "${DOTFILES_DIR}/screenrc.osx" "${HOME}/.screenrc"
elif [ "$(uname)" = 'Linux' ]; then
    safe_create_symlink "${DOTFILES_DIR}/screenrc.ubuntu" "${HOME}/.screenrc"
fi

# zsh completions
DOCKER_MAC_ETC_DIR='/Applications/Docker.app/Contents/Resources/etc'
if [ -d "${DOCKER_MAC_ETC_DIR}" ]; then
    mkdir -p "${HOME}/.zsh/completion"
    safe_create_symlink "${DOCKER_MAC_ETC_DIR}/docker.zsh-completion"         "${HOME}/.zsh/completion/_docker"
    safe_create_symlink "${DOCKER_MAC_ETC_DIR}/docker-compose.zsh-completion" "${HOME}/.zsh/completion/_docker-compose"
fi
