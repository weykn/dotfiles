
## Keybinds

| Key | Action |
|---|---|
| `SUPER + Return` | foot |
| `SUPER + D` | fuzzel launcher |
| `SUPER + G` | `game-runner` - pick a Steam game from fuzzel |
| `SUPER + V` | `clipboard.sh` - cliphist history through fuzzel |
| `SUPER + period` | `emoji.sh` - emoji picker from `unicode-emoji` |
| `SUPER + C` | `calc.sh` - rofi-calc, Enter copies the result |
| `SUPER + S` | `screenshot.sh` - grim + slurp, annotate in swappy |
| `SUPER + P` | `power.sh` - power menu |
| `SUPER + E` | hyprlock |
| `SUPER + SHIFT + R` | `reload.sh` - force-restart waybar, mako, hyprpaper, hypridle |
| `SUPER + SHIFT + E` | `exit.sh` - confirm, then exit Hyprland |

Because the config is Lua, `hyprctl dispatch` needs a Lua dispatcher:
`hyprctl dispatch 'hl.dsp.exit()'`, not `hyprctl dispatch exit`. The keyword
form errors out *and still exits 0*, so it fails silently. For dpms the state
goes under the key `action` — any other argument means toggle:
`hyprctl dispatch 'hl.dsp.dpms({action="off"})'`.

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
| `hyprpaper` | Desktop | Wallpaper daemon (`hyprpaper.conf`, driven by `~/.config/scripts/setbg.sh`) |
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
| `glow` | CLI | Markdown renderer |
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
