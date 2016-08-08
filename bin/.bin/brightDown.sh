FILE=~/.bin/pid/brightness
pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
fi
MAX=930
MIN=10
ACTUAL=$(cat /sys/class/backlight/intel_backlight/brightness)
step=$((($MAX-$MIN)/20))
NEW=$(( ACTUAL - step ))

if [ $NEW -lt $MIN ]
then
    NEW=$((MIN + 1))
fi

echo $NEW | sudo tee /sys/class/backlight/intel_backlight/brightness

palier=$((($MAX-$MIN)/100))
pc=$((($NEW-$MIN)/$palier))

notify-send -p -r $pid -t 1000 -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/status/notification-display-brightness-low.svg "Brightness down" "$(~/.bin/indicBattery.sh $pc 50)"
