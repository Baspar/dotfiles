#!/bin/bash
type=$1
delta=$2

echo $type
if [ "$type" != "keyboard" ] && [ "$type" != "backlight" ]; then
    echo "Invalid type $type (keyboard|brightness)"
    exit 1
fi

FILE=~/.bin/pid/$type
PID=$(cat $FILE)
[ "$PID" ] || {
    PID=$RANDOM
}

hostname=$(uname -n)
case $type in
  keyboard)
      t="leds"
      case $hostname in
          Baspar-frmwk)
              dev="chromeos::kbd_backlight"
              ;;
          *)
              dev="smc::kbd_backlight"
              ;;
      esac
      ;;
  backlight)
      t="backlight"
      dev="intel_backlight"
      ;;
esac

MAX=$(cat /sys/class/$t/$dev/max_brightness)
CURRENT=$(cat /sys/class/$t/$dev/brightness)

PERCENTAGE=$(expr $CURRENT \* 100 / $MAX)
NEW_PERCENTAGE=$(( $PERCENTAGE + $delta ))
[ "$NEW_PERCENTAGE" -gt 100 ] && NEW_PERCENTAGE=100
[ "$NEW_PERCENTAGE" -lt 0 ] && NEW_PERCENTAGE=0

echo $(expr $NEW_PERCENTAGE \* $MAX / 100) > /sys/class/$t/$dev/brightness

PID=$(notify-send.sh \
    -r $PID \
    -t 1000 \
    -p \
    --app-name=BRIGHTNESS \
    --hint=int:value:$NEW_PERCENTAGE \
    "$type ($NEW_PERCENTAGE%)"
)

echo "$PID" > "$FILE"
