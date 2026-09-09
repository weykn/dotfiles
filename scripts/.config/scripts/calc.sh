#!/bin/bash
self="$(readlink -f "$0")"

if [ "$1" = "copy" ]; then
    shift
    result="$*"
    [ -z "$result" ] && exit 0
    printf '%s' "$result" | wl-copy
    notify-send -a calc "copied" "$result"
    exit 0
fi

exec rofi \
    -no-config \
    -theme "$HOME/.config/rofi/calc.rasi" \
    -modi calc \
    -show calc \
    -no-show-icons \
    -display-calc " " \
    -terse \
    -hint-welcome "2+2  ·  15% of 80  ·  10 GB to MB" \
    -hint-result "" \
    -calc-command "$self copy '{result}'" \
    -no-history \
    "$@"
