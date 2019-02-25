FILE=~/.bin/pid/brightness
pid=$(cat $FILE)
if [[ $pid == "" ]]
then
    pid=$RANDOM
    echo "$pid" > $FILE
fi

xbacklight + 10


notify-send \
    -r $pid \
    -t 1000 \
    "$(~/.bin/indicBattery.sh $(xbacklight | cut -d. -f1) -w 50)"
