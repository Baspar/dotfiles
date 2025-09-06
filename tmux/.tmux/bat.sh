#!/bin/bash
if [ $(command -v acpi) ]; then
    # Linux
    INFO=$(acpi | grep -v "unavailable")
    PERCENTAGE=$(echo "$INFO" | grep -o "\([0-9]\+\)%" | sed 's/%//')
    DISCHARGING=$(echo "$INFO" | grep -i "discharging")
    CHARGING=$(echo "$INFO" | grep -i "charging")
    FULL=$(echo "$INFO" | grep -i "full")
elif [ $(command -v pmset) ]; then
    # MacOS
    INFO=$(pmset -g batt)
    PERCENTAGE=$(echo "$INFO" | grep -o "\([0-9]\+\)%" | sed 's/%//')
    DISCHARGING=$(echo "$INFO" | grep -i "discharging")
    CHARGING=$(echo "$INFO" | grep -i "\(charging\|finishing charge\)")
    FULL=$(echo "$INFO" | grep -i "charged")
else
    exit
fi

if [ "$DISCHARGING" ] && [ $PERCENTAGE -lt 10 ]; then
    BG='#AF5F5E'
    FG='#3e3e3e'
elif [ "$DISCHARGING" ] && [ $PERCENTAGE -lt 25 ]; then
    BG='#af875f'
    FG='#3e3e3e'
elif [ "$THEME" = "Light" ]; then
    BG='#7c6f65'
    FG='#fbf0c9'
else
    BG='#af875f'
    FG='#3e3e3e'
fi

ICONS=( "" "" "" "" "" "" "" "" "" "" "" )

if [ -n "$PERCENTAGE" ]; then
    INFO="${ICONS[$(( PERCENTAGE / 10 ))]}$PERCENTAGE%"
else
    INFO=""
fi

echo "#[fg=$BG]$RIGHT_SEPARATOR#[bg=$BG,fg=$FG] $INFO "
