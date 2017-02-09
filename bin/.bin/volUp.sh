FILE=~/.bin/pid/volume
pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
fi

pulseaudio-ctl up 5
etat=$(pulseaudio-ctl full-status | cut -d ' ' -f 2)
pc=$(pulseaudio-ctl full-status | cut -d ' ' -f 1)

if [ $etat == "no" ]
then
    img="low"
    txt="(U)"
else
    img="muted"
    txt="(M)"
fi
echo $pc

notify-send -t 1000 -p -r $pid -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/status/audio-volume-$img.svg "$txt - Volume up" "$(~/.bin/indicBattery.sh $pc 50)"
