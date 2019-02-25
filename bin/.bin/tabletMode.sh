tmp=$(ps aux | grep "avant-window-navigator" | wc -l)
FILE=~/.bin/pid/tabletmode
pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
    echo "$pid" > $FILE
fi

idTS=$(xinput list  | grep Touchscreen | sed 's/.*id=\([0-9]\+\).*/\1/g')
idTP=$(xinput list  | grep TouchPad | sed 's/.*id=\([0-9]\+\).*/\1/g')
if [ $tmp -eq 1 ]
then
    notify-send -p -r $pid -t 1000 -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/actions/gtk-leave-fullscreen.svg "Mode tablette"
    avant-window-navigator&
    onboard&
    touchegg&
    xinput -set-prop $idTP "Device Enabled" 0
    xinput -set-prop $idTS "Device Enabled" 1
    autoRotate.sh&
else
    notify-send -p -r $pid -t 1000 -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/actions/gtk-fullscreen.svg "Mode PC"
    killall avant-window-navigator
    killall onboard
    killall touchegg
    xinput -set-prop $idTP "Device Enabled" 1
    xinput -set-prop $idTS "Device Enabled" 0
    kill -9 $(ps aux | grep autoRotate | grep -v grep | sed 's/\ \+/\ /g' | cut -d ' ' -f 2)
    xrandr --screen 0 -o normal
    xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axes Swap" 0
    xinput set-prop --type=int --format=8 "ELAN Touchscreen" "Evdev Axis Inversion" 0 0
fi
