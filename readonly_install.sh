#!/bin/bash


if [ -x `which git` ]; then
    echo " [$(basename "$0")] readonly install start."
else
    echo " [$(basename "$0")] need git command. please install first."
    exit
fi


E_DIR="environments"
NOW=$(date '+%Y%m%d%H%M%S')
BACKUP_SUFFIX="$NOW""bak"


cd $HOME

if [ -f "$E_DIR" ]; then
    echo " [$(basename "$0")] $(basename "$E_DIR") already exists file."
    echo " [$(basename "$0")] mv $E_DIR $E_DIR""_""$BACKUP_SUFFIX"
    mv "$E_DIR" "$E_DIR""_""$BACKUP_SUFFIX"
    echo " [$(basename "$0")] mkdir $E_DIR"
    mkdir "$E_DIR"
elif [ -d "$E_DIR" ]; then
    echo " [$(basename "$0")] $(basename "$E_DIR") already exists dir."
    if [ -d "$E_DIR""/dotfiles/.git" ]; then
        echo " [$(basename "$0")] dotfiles repository already exists."
        exit
    fi
else
    echo " [$(basename "$0")] mkdir $E_DIR"
    mkdir "$E_DIR"
fi

cd "$E_DIR"
git clone git://github.com/dnpp73/dotfiles.git

cd dotfiles
./setup.sh