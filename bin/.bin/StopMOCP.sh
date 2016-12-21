#!/bin/bash
pid=$(cat ~/.bin/notifypid)
if [[ $pid == "" ]]
then

    pid=1
fi

MOCP=$(ps aux | grep mocp | grep -v grep | wc -l)

if [ $MOCP -ne 0 ]
then
    INFO=$(mocp -i | tr '\n' '#')
    State=$(echo $INFO | tr '#' '\n' | grep State | sed 's/State:\ //g')
    if [[ $State != "STOP" ]]
    then
        song=$(echo $INFO | tr '#' '\n' | grep SongTitle | sed 's/SongTitle:\ //g')
        artist=$(echo $INFO | tr '#' '\n' | grep Artist | sed 's/Artist:\ //g')
        TotalTime=$(echo $INFO | tr '#' '\n' | grep TotalTime | sed 's/TotalTime:\ //g')
        CurrentTime=$(echo $INFO | tr '#' '\n' | grep CurrentTime | sed 's/CurrentTime:\ //g')
    fi
fi
~/.bin/sayMOCP.sh
