#!/bin/bash


# constants
C_DIR=$(cd $(dirname "$0"); pwd)
ORG_DIR="$C_DIR"
[ -L "$0" ] && ORG_DIR=$(cd $(dirname $(readlink "$0")) && pwd)
NOW=$(date '+%Y%m%d%H%M%S')
BACKUP_SUFFIX="$NOW""bak"


#functions
function  safe_create_symlink() {
    if [ -L "$2" ]; then
        echo " [$(basename "$0")] $(basename "$2") already exists symlink."
        exist_link_absolute_dir=$(cd $(dirname $(readlink "$2")) && pwd)
        exist_link_basename=$(basename $(readlink "$2"))
        exist_link_absolute_path="$exist_link_absolute_dir/$exist_link_basename"
        if [ "$1" = "$exist_link_absolute_path" ]; then
            echo " [$(basename "$0")] $(basename "$2") is valid link."
            echo ""
            return
        else
            echo " [$(basename "$0")] mv $2 $2_$BACKUP_SUFFIX"
            mv "$2" "$2_$BACKUP_SUFFIX"
        fi

    elif [ -d "$2" ]; then
        echo " [$(basename "$0")] $(basename "$2") already exists dir."
        echo " [$(basename "$0")] mv $2 $2_$BACKUP_SUFFIX"
        mv "$2" "$2_$BACKUP_SUFFIX"

    elif [ -f "$2" ]; then
        echo " [$(basename "$0")] $(basename "$2") already exists file."
        echo " [$(basename "$0")] mv $2 $2_$BACKUP_SUFFIX"
        mv "$2" "$2_$BACKUP_SUFFIX"

    fi

    echo " [$(basename "$0")] ln -s $1 $2"
    ln -s "$1" "$2"
    echo ""
}



# git submodule (for vim bundle)
echo " [$(basename "$0")] --- install vim bundles ---"

echo " [$(basename "$0")] git submodule update --init"
cd $ORG_DIR && git submodule update --init
echo ""



# oh-my-zsh
echo " [$(basename "$0")] --- install oh-my-zsh ---"

if [ ! -d "$HOME/.oh-my-zsh/.git" ]; then
    echo " [$(basename "$0")] git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh"
    cd $HOME && git clone "git://github.com/robbyrussell/oh-my-zsh.git" "$HOME/.oh-my-zsh"
else
    echo " [$(basename "$0")] already exists oh-my-zsh"
fi

DOTFILES_DIR="$ORG_DIR"
safe_create_symlink "$DOTFILES_DIR/oh-my-zsh/themes" "$HOME/.oh-my-zsh/custom/themes"

echo ""



# dotfiles
echo " [$(basename "$0")] --- install my dotfiles ---"

DOTFILES=("bash_profile" "bashrc" "gitconfig" "gitignore_global" "inputrc" "vimrc" "vim" "gvimrc" "zshrc")

for filename in ${DOTFILES[@]}; do
    safe_create_symlink "$DOTFILES_DIR/$filename" "$HOME/.$filename"
done

# screenrc
if [ `uname` = "Darwin" ]; then
    safe_create_symlink "$DOTFILES_DIR/screenrc.osx" "$HOME/.screenrc"
elif [ `uname` = "Linux" ]; then
    safe_create_symlink "$DOTFILES_DIR/screenrc.ubuntu" "$HOME/.screenrc"
fi



# ssh authorized_keys
echo " [$(basename "$0")] --- install ssh authorized_keys ---"
safe_create_symlink "$ORG_DIR/ssh/authorized_keys" "$HOME/.ssh/authorized_keys"
