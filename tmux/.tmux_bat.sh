#!/bin/bash
BACKGROUND_COLOR=$1

if [ $(command -v acpi) ]
then
    INFO=$(acpi)
    PERCENTAGE=$(echo "$INFO" | grep -o "\([0-9]\+\)%" | sed 's/%//')
    DISCHARGING=$(echo "$INFO" | grep -i "discharging")
    CHARGING=$(echo "$INFO" | grep -i "charging")
elif [ $(command -v m) ]
then
    INFO=$(m battery status)
    PERCENTAGE=$(echo "$INFO" | grep -o "\([0-9]\+\)%" | sed 's/%//')
    DISCHARGING=$(echo "$INFO" | grep -i "discharging")
    CHARGING=$(echo "$INFO" | grep -i "\(charging|finishing charge\)")
    CHARGED=$(echo "$INFO" | grep -i "charged")
fi

[ "$PERCENTAGE" ] || {
    return
}

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
elif [ "$CHARGING" ] ||[ "$CHARGED" ]
then
    COLOR='#4e4e4e'
    FONT='white'
    SIGN=' '
else
    COLOR='red'
    FONT='white'
fi
echo "#[bg=$BACKGROUND_COLOR,fg=$COLOR]#[bg=$COLOR,fg=$FONT] $SIGN$PERCENTAGE% "

#Powerline characters: 
