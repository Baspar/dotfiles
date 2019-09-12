#!/bin/bash
DOTS=$*
ROOT_DIR=$(dirname "$0")

GET_ALL_DOTS () {
    find "$ROOT_DIR/" -type d -maxdepth 1 | sed 's#^\.*##; s#^/*##; /^$/d; /^\./d; s# #\ #g'
}
INSTALL_DOT () {
    DOT="$1"
    echo "Installing $DOT"
    cd "$ROOT_DIR/$DOT"
    DIRS=$(find . -type d | sed 's# #_SPACE_#g')
    for ENCODED_HOME_DIR in $DIRS; do
        HOME_DIR=$(echo $ENCODED_HOME_DIR | sed 's#_SPACE_# #g')
        mkdir -p "$HOME/$HOME_DIR"
    done

    FILES=$(find . -type f | sed 's# #_SPACE_#g')
    for ENCODED_FILE in $FILES; do
        FILE=$(echo $ENCODED_FILE | sed 's#_SPACE_# #g')
        SOURCE_FILE=$(echo "$(pwd)/$FILE" | sed 's#\(/\.\.\)\+/#/#g; s#/\./#/#g')
        DEST_FILE=$(echo "$HOME/$FILE" | sed 's#\(/\.\.\)\+/#/#g; s#/\./#/#g')
        echo -n " $DEST_FILE..."
        if [ -L "$DEST_FILE" ] && [ -e "$DEST_FILE" ] && [ "$SOURCE_FILE" -ef "$DEST_FILE" ]; then
            echo " Already linked"
        elif [ -e "$DEST_FILE" ]; then
            echo "\n Error, file already exists"
        else
            ln -s "$SOURCE_FILE" "$DEST_FILE"
            echo " OK"
        fi
    done

    cd - >> /dev/null
}

if [ $# -eq 0 ]; then
    DOTS=$(GET_ALL_DOTS)
fi

for DOT in $DOTS; do
    if [ -e "$ROOT_DIR/$DOT" ]; then
        INSTALL_DOT "$DOT"
    else
        echo "$ROOT_DIR/$DOT is not a valid directory"
    fi
done
