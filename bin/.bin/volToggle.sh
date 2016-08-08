FILE=~/.bin/pid/volume
pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
fi

etat=$(pulseaudio-ctl full-status | cut -d ' ' -f 2)
old=$(pulseaudio-ctl full-status | cut -d ' ' -f 1)

if [ $etat == "no" ]
then
    img="muted"

    notify-send -t 1000 -p -r $pid -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/status/audio-volume-low.svg "Volume muted" 

    # Fondu
    for i in $(seq $old -5 0)
    do
        pulseaudio-ctl down
    done
    pulseaudio-ctl set 0

    # On toggle le volume
    pulseaudio-ctl mute

    # On remet au bon niveau
    pulseaudio-ctl set $old
else
    img="medium"

    notify-send -t 1000 -p -r $pid -i /home/baspar/.icons/ACYL_Icon_Theme_0.9.4/scalable/real_icons/status/audio-volume-low.svg "Volume unmuted" 

    pulseaudio-ctl set 0

    # On toggle le volume
    pulseaudio-ctl mute

    # Fondu
    for i in $(seq 0 5 $old)
    do
        pulseaudio-ctl up
    done

    # On remet au bon niveau
    pulseaudio-ctl set $old
fi
