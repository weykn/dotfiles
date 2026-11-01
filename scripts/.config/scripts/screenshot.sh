#!/bin/bash
# Freeze the screen first, then select and capture, so nothing can change
# between the keypress and the shot.
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/screenshot.lock"
flock -n 9 || exit 0 # already selecting; a second freeze would capture the first's dim

mkdir -p "$HOME/Pictures/Screenshots" # swappy's save_dir, it won't create it
tmp=$(mktemp --suffix=.png)
freeze_pid=

unfreeze() {
    [ -n "$freeze_pid" ] && kill "$freeze_pid" 2>/dev/null
    freeze_pid=
    makoctl mode -r screenshot-freeze >/dev/null 2>&1
}
trap 'unfreeze; rm -f "$tmp"' EXIT

hyprpicker -r -z -d >/dev/null 2>&1 9>&- &
freeze_pid=$!
# wait for the frozen layer, otherwise an early click lands on hyprpicker and quits it
for _ in {1..40}; do
    hyprctl layers -j | grep -q '"namespace": "hyprpicker"' && break
    sleep 0.05
done
# mako sits on the overlay layer, above the freeze
makoctl mode -a screenshot-freeze >/dev/null 2>&1

geom=$(slurp -b 1b1e22cc -c 6ea8deff -s 6ea8de22 -w 2 9>&-) || exit 0
grim -g "$geom" "$tmp" || exit 1

unfreeze # swappy has to open on the live screen, not under the freeze
flock -u 9
swappy -f "$tmp"
