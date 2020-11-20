FILE=~/.bin/pid/brightness
PID=$(cat $FILE)
[ "$PID" ] || {
    PID=$RANDOM
}

light -U 5

PERCENTAGE=$(light -G | sed 's/\..*$//')
PID=$(notify-send.sh \
    -r $PID \
    -t 1000 \
    -p \
    --app-name=BRIGHTNESS \
    --hint=int:value:$PERCENTAGE \
    "BRIGHTNESS ($PERCENTAGE%)"
)

echo "$PID" > "$FILE"
