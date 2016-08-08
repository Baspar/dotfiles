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
        TotalTime=$(echo "$INFO" | tr '#' '\n' | grep TotalTime | sed 's/TotalTime:\ //g')
        CurrentTime=$(echo "$INFO" | tr '#' '\n' | grep CurrentTime | sed 's/CurrentTime:\ //g')
        echo "$song - $artist" "$CurrentTime/$TotalTime"
        if [[ $State == "PLAY" ]]
        then
            notify-send -p -r $pid -t 1000  -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/actions/gtk-media-play-ltr.svg "$song - $artist" "$CurrentTime/$TotalTime"
        else
            notify-send -p -r $pid -t 1000  -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/actions/gtk-media-pause.svg "$song - $artist" "$CurrentTime/$TotalTime"
        fi
    else
        notify-send -p -r $pid -t 1000  -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/actions/gtk-media-stop.svg "MOCP not playing"
    fi

else
    notify-send -p -r $pid -t 1000  -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/actions/gtk-media-stop.svg "MOCP not running"
fi
