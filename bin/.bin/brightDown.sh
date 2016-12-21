FILE=~/.bin/pid/brightness
pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
fi

xbacklight - 5

notify-send -p -r $pid -t 1000 -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/status/notification-display-brightness-low.svg "Brightness up" "$(~/.bin/indicBattery.sh $(xbacklight | cut -d. -f1) 50)"
