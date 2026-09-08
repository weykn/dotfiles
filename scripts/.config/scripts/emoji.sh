#!/bin/bash
DB=/usr/share/unicode/emoji/emoji-test.txt

if [ ! -r "$DB" ]; then
    notify-send "emoji picker" "Missing $DB — install the 'unicode-emoji' package."
    exit 1
fi

chosen=$(grep -E '; fully-qualified' "$DB" \
    | sed -E 's/^.*# (\S+) E[0-9.]+ (.*)$/\1  \2/' \
    | fuzzel --dmenu --prompt "emoji  " --lines 12 --width 40)

[ -z "$chosen" ] && exit 0
printf '%s' "${chosen%% *}" | wl-copy
notify-send "copied" "${chosen%% *}  ${chosen#*  }"
