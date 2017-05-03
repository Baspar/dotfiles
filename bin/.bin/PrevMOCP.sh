#!/bin/bash

MOCP=$(ps aux | grep mocp | grep -v grep | wc -l)

if [ $MOCP -ne 0 ]
then
    mocp -r
    INFO=$(mocp -i | tr '\n' '#')
    State=$(echo $INFO | tr '#' '\n' | grep State | sed 's/State:\ //g')
    if [[ $State != "STOP" ]]
    then
        sleep 0.5;
        INFO=$(mocp -i | tr '\n' '#')
        song=$(echo $INFO | tr '#' '\n' | grep SongTitle | sed 's/SongTitle:\ //g')
        artist=$(echo $INFO | tr '#' '\n' | grep Artist | sed 's/Artist:\ //g')
        TotalTime=$(echo $INFO | tr '#' '\n' | grep TotalTime | sed 's/TotalTime:\ //g')
        CurrentTime=$(echo $INFO | tr '#' '\n' | grep CurrentTime | sed 's/CurrentTime:\ //g')
    else
        {
            termite -t "MOCP - Music Player" --geometry=800x450+400+225 -e mocp && i3-msg workspace back_and_forth
        }&
    fi
else
    {
        termite -t "MOCP - Music Player" --geometry=800x450+400+225 -e mocp && i3-msg workspace back_and_forth
    }&
fi

~/.bin/sayMOCP.sh
