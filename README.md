# dotfiles_hyprland

Hyprland desktop for Arch, ported from an older i3 setup. Blue palette
throughout: foot for the terminal, fuzzel for the launcher, waybar for the bar.

## Install

Everything is a [GNU stow](https://www.gnu.org/software/stow/) package — one
directory per program, mirroring the layout it wants under `$HOME`.

```sh
git clone https://github.com/<you>/dotfiles_hyprland ~/dotfiles_hyprland
cd ~/dotfiles_hyprland
stow --no-folding -t ~ bin fastfetch foot fuzzel gtk hypr mako rofi waybar zsh
```

Then set a wallpaper once — nothing is shown until you do:

```sh
~/.config/hypr/scripts/setbg.sh ~/.config/hypr/wallpapers/default.jpg
```

## Wallpaper

`hyprpaper.conf` and `hyprlock.conf` both point at a single symlink,
`~/.local/share/wallpapers/current`, and `scripts/setbg.sh` re-points it:

```sh
setbg.sh ~/Pictures/wall.png   # applies live and persists
setbg.sh                       # print the current one
```

Because the configs name the symlink rather than the image, changing wallpaper
never edits a tracked file, and the desktop and the lock screen can't drift
apart. The link needs no file extension — both daemons sniff the real format
with libmagic.

> hyprpaper 0.8 removed the old `preload =` / `wallpaper = MON,path` config keys
> and the `preload`/`unload` IPC verbs. Configs written for 0.7 and earlier fail
> to parse and leave every monitor blank.

## Keybinds

`SUPER` is the modifier. Defined in `hypr/.config/hypr/hyprland.lua`.

| Key | Action |
|---|---|
| `Return` | foot |
| `D` | fuzzel launcher |
| `G` | game-runner — pick a Steam game from fuzzel |
| `Q` | close window |
| `F` / `N` | fullscreen / toggle floating |
| `H` `J` `K` `L` (or arrows) | focus; `+SHIFT` moves the window |
| `1`–`0` | workspace; `+SHIFT` sends the window there without following |
| `minus` / `Y` | send to scratchpad / toggle scratchpad |
| `U` | toggle split direction |
| `R` | resize submap (`Escape` or `Return` to leave) |
| `V` / `period` / `C` | clipboard history / emoji picker / calculator |
| `S` | screenshot region → swappy |
| `P` / `E` | power menu / lock |
| `SHIFT+R` / `SHIFT+E` | reload config / exit Hyprland |
| `SUPER` + left/right drag | move / resize the window under the cursor |
| `XF86Audio` raise/lower/mute/micmute | `pactl` on the default sink and source |

Inside the `R` resize submap: `L`/`J` shrink/grow width, `I`/`K` grow/shrink
height, arrows do the same. `Escape` or `Return` leaves it.

## Layout

| Package | Contents |
|---|---|
| `bin` | `~/.local/bin` — `askpass.sh`, `game-runner` |
| `hypr` | compositor, lock, idle, wallpaper, and the scripts behind the keybinds |
| `waybar` `mako` `fuzzel` `foot` `rofi` `gtk` `fastfetch` | one config each |
| `zsh` | `.zshrc` plus the starship prompt |

`hypr` holds `hyprland.lua`, not `hyprland.conf` — given both, Hyprland loads
the Lua one and silently ignores the other, so there is deliberately only one.

## Games (SUPER+G)

`bin/.local/bin/game-runner` lists installed Steam games and non-Steam shortcuts
in fuzzel, with Steam's own names and icons, and hands the pick back to
`steam://rungameid/`.

It started as [bongjutsu/game-runner](https://github.com/bongjutsu/game-runner)
and was rewritten for this setup:

- names come from the `.acf` manifests verbatim instead of being lowercased
- Proton, the Steam Linux Runtimes and the redistributables are filtered out
- non-Steam shortcuts are read from `shortcuts.vdf`, not `screenshots.vdf` —
  the latter keeps every shortcut you have ever deleted, so the list was full of
  stale duplicates
- a shortcut still named after its `.exe` is relabelled with its install folder,
  so `Launcher.exe` shows up as `Red Dead Redemption 2`
- Steam ships icons as JPEG and fuzzel is built `+png +svg` only, so they are
  converted once and cached under `~/.cache/game-runner/icons`

`-l` still takes any dmenu-style launcher, e.g. `game-runner -l dmenu`.

## Packages

| Package | Group | Why it's needed |
|---|---|---|
| `sddm` | Login | Display manager; reads `/usr/share/wayland-sessions/hyprland.desktop` to start the session |
| `hyprland` | Session | The compositor itself |
| `xdg-desktop-portal-hyprland` | Session | Screenshare and file pickers under Wayland |
| `xdg-desktop-portal-gtk` | Session | GTK file-chooser backend behind the portal |
| `xorg-xwayland` | Session | Runs X11-only apps inside the Wayland session |
| `qt6-wayland` | Session | Lets Qt apps run natively on Wayland (`QT_QPA_PLATFORM=wayland`) |
| `polkit-gnome` | Session | GUI authentication prompts; started via `exec-once` in `hyprland.lua` |
| `hyprpaper` | Desktop | Wallpaper daemon (`hyprpaper.conf`, driven by `scripts/setbg.sh`) |
| `hypridle` | Desktop | DPMS blank at 15 min and lock-before-sleep |
| `hyprlock` | Desktop | Lock screen for SUPER+E and the power menu |
| `waybar` | Desktop | The status bar |
| `mako` | Desktop | Notification daemon; target of every `notify-send` in the scripts |
| `fuzzel` | Desktop | SUPER+D launcher and the `--dmenu` backend for clipboard/emoji/power/exit/askpass |
| `cliphist` | Scripts | Clipboard history store behind `clipboard.sh` (SUPER+V) |
| `wl-clipboard` | Scripts | `wl-paste --watch` feeds cliphist; `wl-copy` pastes back |
| `grim` | Scripts | Screen capture half of `screenshot.sh` (SUPER+S) |
| `slurp` | Scripts | Region selection for `screenshot.sh` |
| `swappy` | Scripts | Annotate/save step after the screenshot |
| `rofi` | Scripts | Front-end for `calc.sh` (SUPER+C) |
| `rofi-calc` | Scripts | Calculator mode for rofi; pulls `libqalculate` for the maths |
| `unicode-emoji` | Scripts | Provides `/usr/share/unicode/emoji/emoji-test.txt` read by `emoji.sh` (SUPER+.) |
| `udisks2` | Storage | Mount/unmount backend for removable media |
| `udiskie` | Storage | `exec-once = udiskie --tray` — automounts USB drives |
| `thunar` | Storage | File manager, run as `thunar --daemon` |
| `thunar-volman` | Storage | Removable-media handling inside Thunar |
| `pipewire` | Audio | Core audio server |
| `pipewire-pulse` | Audio | PulseAudio compatibility; `pactl` drives the XF86Audio volume keys |
| `wireplumber` | Audio | PipeWire session/policy manager — without it nothing gets routed |
| `pavucontrol` | Audio | Opened by waybar's pulseaudio module on click |
| `networkmanager` | Network | Network stack; waybar's network module reads its state |
| `ttf-jetbrains-mono-nerd` | Fonts | Font named by foot, waybar, fuzzel, mako and hyprlock — without it every glyph is a box |
| `inter-font` | Fonts | GTK UI font (`gtk-font-name=Inter 11`) |
| `noto-fonts-emoji` | Fonts | Colour emoji in the bar, notifications and emoji picker |
| `foot` | Terminal | `$terminal` in `hyprland.lua`, bound to SUPER+Return |
| `zsh` | Shell | Login shell; hardcoded in `foot.ini` |
| `zsh-autosuggestions` | Shell | Sourced by `.zshrc` from `/usr/share/zsh/plugins/` — history-based inline suggestions |
| `zsh-syntax-highlighting` | Shell | Sourced by `.zshrc` — command-line syntax colouring |
| `zsh-history-substring-search` | Shell | Sourced by `.zshrc` — up/down substring history search |
| `zsh-completions` | Shell | Extra completion definitions loaded by `.zshrc` |
| `starship` | Shell | Prompt, plus the transient-prompt setup |
| `fastfetch` | Shell | Greeting printed on each new interactive shell |
| `eza` | CLI | `ls`/`ll`/`la` aliases in `.zshrc` |
| `bat` | CLI | `catt` alias / pager for file viewing |
| `fd` | CLI | Fast find; also the finder backend for fzf |
| `fzf` | CLI | Fuzzy-finder keybindings in `.zshrc` |
| `zoxide` | CLI | The `z` jump-to-directory command |
| `less` | CLI | Pager used by git, man and the shell |
| `vim` | CLI | `$EDITOR` / `$VISUAL` — the default set in `.zshrc:7` |
| `git` | CLI | Clones and tracks the dotfiles repos |
| `stow` | CLI | Symlinks the packages below into `$HOME` — every config here is a stow symlink |
| `steam` | Games | Backing store for `game-runner` (SUPER+G) — reads its `libraryfolders.vdf`, `appmanifest_*.acf` and `shortcuts.vdf` |
| `python3` | Games | Builds the `game-runner` catalogue; `shortcuts.vdf` is binary VDF |
| `imagemagick` | Games | Converts Steam's JPEG app icons to the PNG fuzzel can render |
