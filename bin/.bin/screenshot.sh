#!/bin/env bash
if [ "$1" = "--clipboard" ]; then
    TYPE="clipboard"
else
    TYPE="file"
fi

MODE=$(echo -e "Window\nScreen\nRegion" | rofi \
    -dmenu \
    -p "Will be stored in $TYPE> " \
    -i \
    -matching fuzzy \
    -fullscreen \
    -theme "/home/baspar/.config/rofi/baspar.rasi"
)

case "$MODE" in
    Window)
        GEOMETRY=$(
            swaymsg -t get_tree \
                | jq -r ".. \
                    | select(.pid? and .visible?) \
                    | .rect \
                    | \"\(.x),\(.y) \(.width)x\(.height)\"" \
                | slurp
            )
        ;;
    Screen)
        GEOMETRY=$(
            swaymsg -t get_outputs \
                | jq -r ".[] \
                    | select(.active) \
                    | .rect \
                    | \"\(.x),\(.y) \(.width)x\(.height)\"" \
                | slurp
        )
        ;;
    Region)
        GEOMETRY=$(slurp)
        ;;
    *)
        exit
        ;;
esac

[ "$GEOMETRY" ] && {
    if [ "$1" = "--clipboard" ]; then
        grim -g "$GEOMETRY" -t png - | wl-copy -t image/png
        notify-send -t 2000 "Screenshot in clipboard"
    else
        grim -g "$GEOMETRY" -t png
        notify-send -t 2000 "Screenshot saved"
    fi

}
