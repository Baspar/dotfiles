#!/bin/bash
PWD=$(pwd)
DOTS=$*
DIR=$(dirname "$0")

GET_ALL_DOTS () {
    find -depth 1 -type d "$DIR/" | grep -v "\.git"
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
        SOURCE_FILE=$(echo "$(pwd)/$FILE" | sed 's#\(/\.\.\)\+/#/#g; s#/\./#/#g')
        DEST_FILE=$(echo "$HOME/$FILE" | sed 's#\(/\.\.\)\+/#/#g; s#/\./#/#g')
        echo -n " $DEST_FILE..."
        if [ -L "$DEST_FILE" ]; then
            echo " Already linked"
        elif [ -e "$DEST_FILE" ]; then
            echo " Error, file already exists"
        else
            ln -s "$SOURCE_FILE" "$DEST_FILE"
            echo " OK"
        fi
    done
}

if [ $# -eq 0 ]; then
    echo "FInd all"
    DOTS=$(GET_ALL_DOTS)
    echo $DOTS
    exit
fi

for DOT in $DOTS; do
    if [ -e "$DIR/$DOT" ]; then
        INSTALL_DOT "$DIR/$DOT"
    else
        echo "$(basename $DOT) is not a valid directory"
    fi
done

cd "$PWD"
