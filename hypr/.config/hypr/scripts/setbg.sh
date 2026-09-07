#!/usr/bin/env bash
# Set the wallpaper on every monitor — applies immediately AND persists.
#
#   setbg.sh ~/Pictures/wall.png    set a new wallpaper
#   setbg.sh                        show the current one
#
# Persistence is a symlink, not a rewritten config: hyprpaper.conf and
# hyprlock.conf both point at ~/.local/share/wallpapers/current for good, and
# this script just re-points that link. Nothing in the dotfiles repo is touched.
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

# hyprpaper and hyprlock both sniff the format with libmagic, so trust that
# rather than the extension — but fail loudly here instead of silently showing
# a black screen at the next lock.
case "$(file -Lb --mime-type -- "$IMG")" in
    image/png | image/jpeg | image/bmp | image/webp | image/svg+xml | image/jxl | image/avif) ;;
    *) echo "not a supported image: $IMG ($(file -Lb --mime-type -- "$IMG"))" >&2; exit 1 ;;
esac

# persist
mkdir -p "$(dirname "$LINK")"
ln -sfn -- "$IMG" "$LINK"

# apply live. hyprpaper 0.8 removed the preload/unload IPC verbs — `wallpaper`
# is the only one left, it loads on demand, and it wants a real absolute path.
if pgrep -x hyprpaper >/dev/null; then
    hyprctl hyprpaper wallpaper ",$IMG" >/dev/null   # empty monitor = all monitors
else
    echo "note: hyprpaper isn't running; will apply at next login"
fi

echo "wallpaper set: $IMG"
