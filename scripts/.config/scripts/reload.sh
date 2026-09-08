#!/usr/bin/env bash
set -u

DAEMONS=(waybar mako hyprpaper hypridle)

hyprctl reload >/dev/null 2>&1

for d in "${DAEMONS[@]}"; do
    pkill -x "$d" 2>/dev/null
done

for _ in $(seq 20); do
    running=0
    for d in "${DAEMONS[@]}"; do
        pgrep -x "$d" >/dev/null 2>&1 && running=1
    done
    [ "$running" -eq 0 ] && break
    sleep 0.1
done
for d in "${DAEMONS[@]}"; do
    pkill -9 -x "$d" 2>/dev/null
done

started=()
for d in "${DAEMONS[@]}"; do
    if command -v "$d" >/dev/null 2>&1; then
        setsid "$d" >/dev/null 2>&1 &
        started+=("$d")
    fi
done

sleep 0.6
if command -v notify-send >/dev/null 2>&1; then
    notify-send -a reload "  reloaded" "${started[*]}"
fi
