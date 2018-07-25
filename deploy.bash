#!/bin/bash
PWD=$(pwd)
DOTS=$*
DIR=$(dirname "$0")

GET_ALL_DOTS () {
    find "$DIR" -depth 1 -type d | grep -v "\.git"
}
INSTALL_DOT () {
    DOT="$1"
    echo "Installing $DOT"
    cd "$DIR/$DOT"
    DIRS=$(find . -type d)
    for DIR in $DIRS; do
        mkdir -p "$HOME/$DIR"
    done

    FILES=$(find . -type f)
    for FILE in $FILES; do
        echo -n " $HOME/$FILE..."
        if [ -L "$HOME/$FILE" ]; then
            echo " ALREADY LINKED"
        elif [ -e "$HOME/$FILE" ]; then
            echo " ERR"
        else
            ln -s "$(pwd)/$FILE" "$HOME/$FILE"
            echo " OK"
        fi
    done
}

if [ $# -eq 0 ]; then
    DOTS=$(GET_ALL_DOTS)
fi

for DOT in $DOTS; do
    if [ -e "$DIR/$DOT" ]; then
        INSTALL_DOT "$DIR/$DOT"
    else
        echo "$(basename $DOT) is not a valid directory"
    fi
done

cd "$PWD"
