#!/usr/bin/env bash
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
COLOR_RESET=$(tput sgr0)
CLEAR_LINE=$(tput el)

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

    FILES=$(find . \( -type l -o -type f \) | sed 's# #_SPACE_#g')
    for ENCODED_FILE in $FILES; do
        FILE=$(echo $ENCODED_FILE | sed 's#_SPACE_# #g')
        SOURCE_FILE=$(echo "$(pwd)/$FILE" | sed 's#\(/\.\.\)\+/#/#g; s#/\./#/#g')
        DEST_FILE=$(echo "$HOME/$FILE" | sed 's#\(/\.\.\)\+/#/#g; s#/\./#/#g')
        echo -e -n "  $FILE...\r"
        if [ -L "$DEST_FILE" ] && [ -e "$DEST_FILE" ] && [ "$SOURCE_FILE" -ef "$DEST_FILE" ]; then
            rm -rf "$DEST_FILE"
            echo -e "\r  $GREEN$FILE...$COLOR_RESET Removed"
        elif [ -e "$DEST_FILE" ]; then
            echo -e "\r  $RED$FILE...$COLOR_RESET Error, file was not set by deploy.bash"
        else
            echo -e "\r  $YELLOW$FILE...$COLOR_RESET Is not linked"
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

    tput cud1
    echo -en "$CLEAR_LINE$YELLOW  $COLOR_RESET Installing $DOT"
    tput cuu1

    cd "$ROOT_DIR/$DOT"
    DIRS=$(find . -type d | sed 's# #_SPACE_#g')
    for ENCODED_HOME_DIR in $DIRS; do
        HOME_DIR=$(echo $ENCODED_HOME_DIR | sed 's#_SPACE_# #g')
        mkdir -p "$HOME/$HOME_DIR"
    done

    FILES=$(find . \( -type l -o -type f \) | sed 's# #_SPACE_#g')
    for ENCODED_FILE in $FILES; do
        FILE=$(echo $ENCODED_FILE | sed 's#_SPACE_# #g')
        SOURCE_FILE=$(echo "$(pwd)/$FILE" | sed 's#\(/\.\.\)\+/#/#g; s#/\./#/#g')
        DEST_FILE=$(echo "$HOME/$FILE"    | sed 's#\(/\.\.\)\+/#/#g; s#/\./#/#g')
        if [ -L "$DEST_FILE" ] && [ -e "$DEST_FILE" ] && [ "$SOURCE_FILE" -ef "$DEST_FILE" ]; then
            echo -en "\r$CLEAR_LINE  $YELLOW$FILE...$COLOR_RESET Already linked"
            continue
        fi

        if [ -e "$DEST_FILE" ]; then
            echo -e "\r$CLEAR_LINE  $RED  $FILE...$COLOR_RESET Error, file already exists"
        else
            ln -s "$SOURCE_FILE" "$DEST_FILE"
            echo -e "\r$CLEAR_LINE  $GREEN  $FILE...$COLOR_RESET OK"
        fi

        tput cud1
        echo -en "$CLEAR_LINE$YELLOW  $COLOR_RESET Installing $DOT"
        tput cuu1
    done
    echo -e "\r$CLEAR_LINE$GREEN  $COLOR_RESET Installed $DOT"

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
