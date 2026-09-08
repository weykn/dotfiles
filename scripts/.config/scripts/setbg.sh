#!/usr/bin/env bash
set -euo pipefail

LINK="${XDG_DATA_HOME:-$HOME/.local/share}/wallpapers/current"

if [ $# -eq 0 ]; then
    if [ -L "$LINK" ]; then
        echo "current: $(readlink -f "$LINK")"
    else
        echo "no wallpaper set"
    fi
    echo "usage: setbg.sh /path/to/image"
    exit 0
fi

IMG="$(readlink -f -- "$1")"
[ -f "$IMG" ] && [ -r "$IMG" ] || { echo "cannot read: $1" >&2; exit 1; }

case "$(file -Lb --mime-type -- "$IMG")" in
    image/png | image/jpeg | image/bmp | image/webp | image/svg+xml | image/jxl | image/avif) ;;
    *) echo "not a supported image: $IMG ($(file -Lb --mime-type -- "$IMG"))" >&2; exit 1 ;;
esac

mkdir -p "$(dirname "$LINK")"
ln -sfn -- "$IMG" "$LINK"

if pgrep -x hyprpaper >/dev/null; then
    hyprctl hyprpaper wallpaper ",$IMG" >/dev/null
else
    echo "note: hyprpaper isn't running; will apply at next login"
fi

echo "wallpaper set: $IMG"
