#!/bin/bash
FILE=~/.bin/pid/battery

seuil=20 # Seuil d'alerte
suspendPC=5 # Seuil de mise en veille

pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
fi

batTot=$(cat /sys/class/power_supply/BAT0/charge_full)
bat=$(( 100 * $(cat /sys/class/power_supply/BAT0/charge_now) / batTot ))

state=$(cat /sys/class/power_supply/BAT0/status)
oldBat=$(cat ~/.bin/battery.d | head -n 1)
oldState=$(cat ~/.bin/battery.d | head -n 2 | tail -n 1)

# Ecriture des données dans fichier
echo $bat > ~/.bin/battery.d
echo $state >> ~/.bin/battery.d

export DISPLAY=:0.0
if [[ $state != $oldState ]]
then
    notify-send -p -r $pid -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/devices/battery.svg "Battery $state" "Battery at $bat%"> $FILE
elif [ $bat -lt $oldBat ]
then
    if [ $bat -le $suspendPC ]
    then
        notify-send -p -r $pid -u critical -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/devices/battery.svg "Suspending!" "Batterie a $bat%" > $FILE
        sleep 5 && systemctl suspend
    elif [ $bat -le $seuil ]
    then
        notify-send -p -r $pid -u critical -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/devices/battery.svg "Battery at $bat%" > $FILE
    fi
elif [ $bat -eq 100 ] && [ $oldBat -ne 100 ]
then
        notify-send -p -r $pid -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/devices/battery.svg "Battery at $bat%" > $FILE
fi
