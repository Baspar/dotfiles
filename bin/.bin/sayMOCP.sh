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
        TOTAL_SEC=$(echo "$MOCP_INFO" | tr '#' '\n' | grep TotalSec | sed 's/TotalSec:\ //g')
        CURRENT_SEC=$(echo "$MOCP_INFO" | tr '#' '\n' | grep CurrentSec | sed 's/CurrentSec:\ //g')
        TOTAL_TIME=$(echo "$MOCP_INFO" | tr '#' '\n' | grep TotalTime | sed 's/TotalTime:\ //g')
        CURRENT_TIME=$(echo "$MOCP_INFO" | tr '#' '\n' | grep CurrentTime | sed 's/CurrentTime:\ //g')
        PERCENTAGE=$((100 * CURRENT_SEC / TOTAL_SEC))

        if [[ $(mocp -i | grep State | cut -d' ' -f 2) == 'PLAY' ]]
        then
            CHAR="█"
        else
            CHAR="░"
        fi

        TITLE="$STATUS $SONG - $ARTIST
        $CURRENT_TIME$(~/.bin/indicBattery.sh $PERCENTAGE 30 $CHAR)  $TOTAL_TIME"
    else
        TITLE="MOCP not playing"
    fi

else
    TITLE="MOCP not running"
fi

notify-send \
    -r $pid \
    -t 1000  \
    "$TITLE"
