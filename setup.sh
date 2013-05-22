#!/bin/bash


# constants
C_DIR=$(cd $(dirname "$0"); pwd)
ORG_DIR="$C_DIR"
[ -L "$0" ] && ORG_DIR=$(cd $(dirname $(readlink "$0")) && pwd)
NOW=$(date '+%Y%m%d%H%M%S')
BACKUP_SUFFIX="$NOW""bak"

#functions
function  safe_create_symlink() {
    if [ -d "$2" ]; then
        echo " [$(basename "$0")] $(basename "$2") already exists dir."
        echo " [$(basename "$0")] mv $2 $2_$BACKUP_SUFFIX"
        mv "$2" "$2_$BACKUP_SUFFIX"
    elif [ -L "$2" ]; then
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

    elif [ -f "$2" ]; then
        echo " [$(basename "$0")] $(basename "$2") already exists file."
        echo " [$(basename "$0")] mv $2 $2_$BACKUP_SUFFIX"
        mv "$2" "$2_$BACKUP_SUFFIX"
    fi

    echo " [$(basename "$0")] ln -s $1 $2"
    ln -s "$1" "$2"
    echo ""
}


# dotfiles
DOTFILES_DIR="$ORG_DIR"
DOTFILES=("bash_profile" "bashrc" "gitconfig" "gitignore_global" "inputrc" "vimrc" "vim")

for filename in ${DOTFILES[@]}; do
    safe_create_symlink "$DOTFILES_DIR/$filename" "$HOME/.$filename"
done

# screenrc
if [ `uname` = "Darwin" ]; then
    safe_create_symlink "$DOTFILES_DIR/screenrc.osx" "$HOME/.screenrc"
elif [ `uname` = "Linux" ]; then
    safe_create_symlink "$DOTFILES_DIR/screenrc.ubuntu" "$HOME/.screenrc"
fi
