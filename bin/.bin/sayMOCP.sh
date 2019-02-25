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

        TEXT="$CURRENT_TIME $(~/.bin/indicBattery.sh $PERCENTAGE -w 50 -c $CHAR) $TOTAL_TIME"
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
