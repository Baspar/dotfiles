#!/bin/bash
BACKGROUND_COLOR=$1

if [ $(command -v acpi) ]
then
    INFO=$(acpi)
    PERCENTAGE=$(echo "$INFO" | grep -o "\([0-9]\+\)%" | sed 's/%//')
    DISCHARGING=$(echo "$INFO" | grep -i "discharging")
    CHARGING=$(echo "$INFO" | grep -i "charging")
elif [ $(command -v pmset) ]
then
    INFO=$(pmset -g batt)
    PERCENTAGE=$(echo "$INFO" | grep -o "\([0-9]\+\)%" | sed 's/%//')
    DISCHARGING=$(echo "$INFO" | grep -i "discharging")
    CHARGING=$(echo "$INFO" | grep -i "\(charging\|finishing charge\)")
    CHARGED=$(echo "$INFO" | grep -i "charged")
fi

[ "$PERCENTAGE" ] || {
    return
}

if [ "$DISCHARGING" ]
then
    if [ $PERCENTAGE -lt 10 ]
    then
        COLOR='#AF5F5E'
        FONT='#3e3e3e'
    elif [ $PERCENTAGE -lt 25 ]
    then
        COLOR='#af875f'
        FONT='#3e3e3e'
    else
        COLOR='#4e4e4e'
        FONT='white'
    fi
elif [ "$CHARGING" ] ||[ "$CHARGED" ]
then
    COLOR='#4e4e4e'
    FONT='white'
    SIGN='ϟ '
else
    COLOR='#AF5F5E'
    FONT='white'
fi
echo "#[bg=$BACKGROUND_COLOR,fg=$COLOR]$RIGHT_SEPARATOR#[bg=$COLOR,fg=$FONT] $PERCENTAGE% $SIGN"

