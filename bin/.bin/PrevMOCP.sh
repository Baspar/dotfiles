#!/bin/bash
pid=$(cat ~/.bin/notifypid)
if [[ $pid == "" ]]
then

    pid=1
fi

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
        notify-send -p -r $pid -t 1000 -u critical -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/actions/gtk-media-next-rtl.svg "$song - $artist" "$CurrentTime/$TotalTime" > ~/.bin/notifypid
    else
        notify-send -p -r $pid -t 1000 -u critical -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/actions/gtk-media-stop.svg "Pas de musique en cours" > ~/.bin/notifypid
        termite --geometry=800x450+400+225 -e mocp
    fi
else
    notify-send -p -r $pid -t 1000 -u critical -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/actions/gtk-media-stop.svg "MOCP non lancé" > ~/.bin/notifypid
    termite --geometry=800x450+400+225 -e mocp
fi
