#!/usr/bin/env bash
DOTS=""
MODE="INSTALL"
for DOT in $*
do
    [ "$DOT" == "-u" ] && {
        MODE="UNINSTALL"
    } || {
        DOTS="$DOTS $DOT"
    }
done

ROOT_DIR=$(dirname "$0")

GET_ALL_DOTS () {
    find "$ROOT_DIR/" -maxdepth 1 -type d \
        | sed "s#^$ROOT_DIR/##" \
        | sed 's#^\.*##; s#^/*##; /^$/d; /^\./d; s# #\ #g'
}

UNINSTALL_DOT () {
    DOT="$1"
    echo "Uninstalling $DOT"
    cd "$ROOT_DIR/$DOT"

    FILES=$(find . -type f | sed 's# #_SPACE_#g')
    for ENCODED_FILE in $FILES; do
        FILE=$(echo $ENCODED_FILE | sed 's#_SPACE_# #g')
        SOURCE_FILE=$(echo "$(pwd)/$FILE" | sed 's#\(/\.\.\)\+/#/#g; s#/\./#/#g')
        DEST_FILE=$(echo "$HOME/$FILE" | sed 's#\(/\.\.\)\+/#/#g; s#/\./#/#g')
        echo -n "  $FILE..."
        if [ -L "$DEST_FILE" ] && [ -e "$DEST_FILE" ] && [ "$SOURCE_FILE" -ef "$DEST_FILE" ]; then
            rm -rf "$DEST_FILE"
            echo -e " \e[32mRemoved\e[0m"
        elif [ -e "$DEST_FILE" ]; then
            echo -e " \e[31mError, file was not set by deploy.bash\e[0m"
        else
            echo -e " \e[33mIs not linked\e[0m"
        fi
    done

    DIRS=$(find . -type d | sed 's# #_SPACE_#g' | tac)
    for ENCODED_HOME_DIR in $DIRS; do
        HOME_DIR=$(echo $ENCODED_HOME_DIR | sed 's#_SPACE_# #g')
        [ -d "$HOME/$HOME_DIR" ] || continue
        FILES_IN_DIR=$(ls -A "$HOME/$HOME_DIR")
        [ -z "$FILES_IN_DIR" ] && {
            echo "  Removing empty $HOME_DIR"
            rm -rf "$HOME/$HOME_DIR"
        }
    done

    cd - >> /dev/null
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
        echo -n "  $FILE..."
        if [ -L "$DEST_FILE" ] && [ -e "$DEST_FILE" ] && [ "$SOURCE_FILE" -ef "$DEST_FILE" ]; then
            echo -e " \e[33mAlready linked\e[0m"
        elif [ -e "$DEST_FILE" ]; then
            echo -e " \e[31mError, file already exists\e[0m"
        else
            ln -s "$SOURCE_FILE" "$DEST_FILE"
            echo -e " \e[32mOK\e[0m"
        fi
    done

    cd - >> /dev/null
}

[ "$DOTS" ] || {
    DOTS=$(GET_ALL_DOTS)
}

for DOT in $DOTS; do
    if [ -e "$ROOT_DIR/$DOT" ]; then
        [ "$MODE" == "INSTALL" ] && {
            INSTALL_DOT "$DOT"
        } || {
            UNINSTALL_DOT "$DOT"
        }
    else
        echo "$ROOT_DIR/$DOT is not a valid directory"
    fi
done
