#!/bin/bash
if [ $(command -v acpi) ]; then
    INFO=$(acpi)
    PERCENTAGE=$(echo "$INFO" | grep -o "\([0-9]\+\)%" | sed 's/%//')
    DISCHARGING=$(echo "$INFO" | grep -i "discharging")
    CHARGING=$(echo "$INFO" | grep -i "charging")
    FULL=$(echo "$INFO" | grep -i "full")
elif [ $(command -v pmset) ]; then
    INFO=$(pmset -g batt)
    PERCENTAGE=$(echo "$INFO" | grep -o "\([0-9]\+\)%" | sed 's/%//')
    DISCHARGING=$(echo "$INFO" | grep -i "discharging")
    CHARGING=$(echo "$INFO" | grep -i "\(charging\|finishing charge\)")
    FULL=$(echo "$INFO" | grep -i "charged")
fi

if [ "$DISCHARGING" ]; then
    if [ $PERCENTAGE -lt 10 ]; then
        COLOR='#AF5F5E'
        FONT='#3e3e3e'
    elif [ $PERCENTAGE -lt 25 ]; then
        COLOR='#af875f'
        FONT='#3e3e3e'
    else
        COLOR='#4e4e4e'
        FONT='white'
    fi
elif [ "$CHARGING" ] || [ "$FULL" ]; then
    COLOR='#4e4e4e'
    FONT='white'
else
    COLOR='#AF5F5E'
    FONT='black'
fi

ICONS=( "" "" "" "" "" "" "" "" "" "" "" )

if [ -n "$PERCENTAGE" ]; then
    INFO="${ICONS[$(( PERCENTAGE / 10 ))]}$PERCENTAGE%"
else
    INFO=""
fi

echo "#[fg=$COLOR]$RIGHT_SEPARATOR#[bg=$COLOR,fg=$FONT] $INFO "
