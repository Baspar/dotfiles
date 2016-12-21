#!/bin/bash
FILE=~/.bin/pid/moc

pid=$(cat $FILE)
if [[ $pid == "" ]]
then

    pid=$RANDOM
fi

MOCP=$(ps aux | grep mocp | grep -v grep | wc -l)

if [ $MOCP -ne 0 ]
then
    INFO=$(mocp -i | tr '\n' '#')
    State=$(echo "$INFO" | tr '#' '\n' | grep State | sed 's/State:\ //g')
    if [[ $State != "STOP" ]]
    then
        song=$(echo "$INFO" | tr '#' '\n' | grep SongTitle | sed 's/SongTitle:\ //g')
        artist=$(echo "$INFO" | tr '#' '\n' | grep Artist | sed 's/Artist:\ //g')
        TotalSec=$(echo "$INFO" | tr '#' '\n' | grep TotalSec | sed 's/TotalSec:\ //g')
        CurrentSec=$(echo "$INFO" | tr '#' '\n' | grep CurrentSec | sed 's/CurrentSec:\ //g')
        TotalTime=$(echo "$INFO" | tr '#' '\n' | grep TotalTime | sed 's/TotalTime:\ //g')
        CurrentTime=$(echo "$INFO" | tr '#' '\n' | grep CurrentTime | sed 's/CurrentTime:\ //g')
        percentage=$((100 * CurrentSec / TotalSec))

        status="[ $([[ $(mocp -i | grep State | cut -d' ' -f 2) == 'PLAY' ]] && echo '|>' || echo '||') ]"

        title="$status $song - $artist"
        descr="$CurrentTime  $(~/.bin/indicBattery.sh $percentage 30)  $TotalTime"
    else
        title="MOCP not playing"
    fi

else
    title="MOCP not running"
    descr=""
fi

notify-send -p -r $pid -t 1000  -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/actions/gtk-media-stop.svg "$title" "$descr"
