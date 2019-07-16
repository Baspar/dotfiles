#!/bin/bash
BACKGROUND_COLOR=$1

if [ $(command -v acpi) ]
then
    INFO=$(acpi)
    [ $INFO ] || return
    PERCENTAGE=$(echo $INFO | grep -o "\([0-9]\+\)%" | sed 's/%//')
    DISCHARGING=$(echo $INFO | grep -i "discharging")
    CHARGING=$(echo $INFO | grep -i "charging")

    if [ "$DISCHARGING" ]
    then
        if [ $PERCENTAGE -lt 10 ]
        then
            COLOR='red'
            FONT='#3e3e3e'
        elif [ $PERCENTAGE -lt 25 ]
        then
            COLOR='yellow'
            FONT='#3e3e3e'
        else
            COLOR='#4e4e4e'
            FONT='white'
        fi
    elif [ "$CHARGING" ]
    then
        COLOR='#4e4e4e'
        FONT='white'
    else
        COLOR='red'
        FONT='white'
    fi
    echo "#[bg=$BACKGROUND_COLOR,fg=$COLOR]#[bg=$COLOR,fg=$FONT] $PERCENTAGE% "
fi

#Powerline characters: 
