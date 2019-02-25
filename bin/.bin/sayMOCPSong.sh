#!/bin/bash
FILE=~/.bin/pid/moc

pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
    echo "$pid" > $FILE
fi

MOCP_RUNNING=$(ps aux | grep mocp | grep -v grep | wc -l)
MOCP_INFO=$(mocp -i | tr '\n' '#')
MOCP_STATE=$(echo "$MOCP_INFO" | tr '#' '\n' | grep State | sed 's/State:\ //g')

if [ $MOCP_RUNNING -ne 0 ]
then
    if [[ $MOCP_STATE != "STOP" ]]
    then
        SONG=$(echo "$MOCP_INFO" | tr '#' '\n' | grep SongTitle | sed 's/SongTitle:\ //g')
        ARTIST=$(echo "$MOCP_INFO" | tr '#' '\n' | grep Artist | sed 's/Artist:\ //g')
        TEXT="$SONG - $ARTIST"
    else
        TEXT="MOCP not playing"
    fi
else
    TEXT="MOCP not running"
fi

notify-send \
    -r $pid \
    -t 1000  \
    "$TEXT"
