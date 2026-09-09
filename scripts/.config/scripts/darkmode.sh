#!/usr/bin/env bash
# Tell every toolkit that this session is dark.
#
# GTK apps read ~/.config/gtk-{3,4}.0/settings.ini, but Chromium/Brave on the
# "Device" theme, Firefox, and Electron apps ask xdg-desktop-portal instead,
# over org.freedesktop.appearance -> color-scheme. xdg-desktop-portal-gtk
# derives that value from the gsettings keys set here, so these are the real
# switch — settings.ini alone leaves the portal reporting "no preference" (0)
# and those apps fall back to light.
#
# Run from hyprland.lua on session start; the portal emits SettingChanged, so
# already-running apps follow along without a restart.
set -u

command -v gsettings >/dev/null 2>&1 || exit 0

gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme    Adwaita-dark
gsettings set org.gnome.desktop.interface icon-theme   Adwaita
gsettings set org.gnome.desktop.interface cursor-theme Adwaita
gsettings set org.gnome.desktop.interface font-name    "Inter 11"
