#!/bin/bash
# Parameters
THRESHOLD_WARNING=20
THRESHOLD_ALERT=5
PID_FILE=~/.bin/PID/battery
BATTERY_NUMBER=0

# Set
PID=$(cat $PID_FILE)
if [[ $PID == "" ]]
then
    PID=$RANDOM
    echo $PID > PID_FILE
fi

STATUS=$(cat /sys/class/power_supply/BAT$BATTERY_NUMBER/status)
FULL=$(cat /sys/class/power_supply/BAT$BATTERY_NUMBER/charge_full)
CURRENT=$(cat /sys/class/power_supply/BAT$BATTERY_NUMBER/charge_now)

OLD_BATTERY_LEVEL=$(cat ~/.bin/battery.d | head -n 1)
OLD_CHARGING_STATE=$(cat ~/.bin/battery.d | head -n 2 | tail -n 1)

# Ecriture des données dans fichier
echo $BATTERY_LEVEL > ~/.bin/battery.d
echo $CHARGING_STATE >> ~/.bin/battery.d

export DISPLAY=:0.0
if [[ $CHARGING_STATE != $OLD_CHARGING_STATE ]]
then
    notify-send -p -r $PID -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/devices/battery.svg "Battery $CHARGING_STATE" "Battery at $BATTERY_LEVEL%"> $PID_FILE
elif [ $BATTERY_LEVEL -lt $OLD_BATTERY_LEVEL ]
then
    if [ $BATTERY_LEVEL -le $THRESHOLD_ALERT ]
    then
        notify-send -p -r $PID -u critical -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/devices/battery.svg "Suspending!" "Battery at $BATTERY_LEVEL%" > $PID_FILE
        sleep 5 && systemctl suspend
    elif [ $BATTERY_LEVEL -le $THRESHOLD_WARNING ]
    then
        notify-send -p -r $PID -u critical -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/devices/battery.svg "Battery at $BATTERY_LEVEL%" > $PID_FILE
    fi
elif [ $BATTERY_LEVEL -eq 100 ] && [ $OLD_BATTERY_LEVEL -ne 100 ]
then
        notify-send -p -r $PID -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/devices/battery.svg "Battery at $BATTERY_LEVEL%" > $PID_FILE
fi
