-- ============================================================
--  Hyprland — Lua config (0.56+ format)
--  THIS is the file Hyprland loads: given both, it prefers hyprland.lua over
--  hyprland.conf, so a stray .conf next to this one would silently do nothing.
--  Ported 1:1 from the old i3 config.
-- ============================================================

local mod      = "SUPER"
local terminal = "foot"
local menu     = "fuzzel"
local scripts  = os.getenv("HOME") .. "/.config/hypr/scripts"
-- SDDM starts the session without ~/.local/bin on PATH, so anything stowed
-- from the `bin` package has to be bound by absolute path.
local bin      = os.getenv("HOME") .. "/.local/bin"

-- ---------- Blue palette ----------
local c = {
    accent    = "rgba(6ea8deff)",
    accent2   = "rgba(8fd0e8ff)",
    unfocused = "rgba(3a3c44ff)",
}

-- ---------- Monitors ----------
-- i3: xrandr --output HDMI-2 --auto --primary --output HDMI-1 --auto --right-of HDMI-2
hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@144", position = "0x0",    scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@144", position = "1920x0", scale = 1 })
hl.monitor({ output = "",         mode = "preferred",     position = "auto",   scale = "auto" })

-- ---------- Environment ----------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

-- ---------- Autostart (from i3 exec_always) ----------
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("udiskie --tray")
    hl.exec_cmd("thunar --daemon")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    -- clipmenud -> cliphist
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    -- nm-applet / dex are not installed here, so the equivalent i3 lines are
    -- left off on purpose; add them back if you ever install them.
end)

-- ---------- Look & feel ----------
hl.config({
    general = {
        gaps_in     = 4,
        gaps_out    = 8,
        border_size = 2,
        col = {
            active_border   = { colors = { c.accent, c.accent2 }, angle = 45 },
            inactive_border = c.unfocused,
        },
        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 8,
        active_opacity   = 1.0,
        inactive_opacity = 0.97,
        blur = {
            enabled           = true,
            size              = 6,
            passes            = 3,
            new_optimizations = true,
            ignore_opacity    = true,
            xray              = false,
        },
        shadow = {
            enabled      = true,
            range        = 18,
            render_power = 3,
            color        = 0x66000000,
        },
    },

    animations = { enabled = true },

    dwindle = {
        -- replaces autotile.py: splits follow window aspect ratio
        preserve_split = false,
        smart_split    = false,
    },

    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        force_default_wallpaper  = 0,
    },

    input = {
        kb_layout     = "us",
        follow_mouse  = 1,
        sensitivity   = 0,
        accel_profile = "flat",
    },
})

-- ---------- Animations ----------
hl.curve("smooth", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })
hl.curve("snap",   { type = "bezier", points = { { 0.2,  1.0 }, { 0.2, 1.0 } } })

hl.animation({ leaf = "windows",          enabled = true, speed = 4, bezier = "smooth", style = "popin 90%" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 4, bezier = "smooth", style = "popin 90%" })
hl.animation({ leaf = "border",           enabled = true, speed = 8, bezier = "smooth" })
hl.animation({ leaf = "fade",             enabled = true, speed = 4, bezier = "smooth" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 4, bezier = "snap", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "snap", style = "slidevert" })

-- ---------- Window rules ----------
hl.window_rule({
    name  = "float-dialogs",
    match = { class = "^(pavucontrol|nm-connection-editor|blueman-manager|udiskie|xdg-desktop-portal-gtk)$" },
    float = true,
})

hl.window_rule({
    name  = "pip",
    match = { title = "^(Picture-in-Picture)$" },
    float = true,
    pin   = true,
})

hl.window_rule({
    name           = "no-maximize-requests",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- ---------- Layer rules ----------
hl.layer_rule({
    name  = "blur-waybar",
    match = { namespace = "waybar" },
    blur  = true,
    -- bar background is transparent — only blur behind the opaque islands
    ignore_alpha = 0.35,
})

hl.layer_rule({
    name         = "blur-launcher",
    match        = { namespace = "launcher" },
    blur         = true,
    ignore_alpha = 0.35,
})

hl.layer_rule({
    name  = "blur-notifications",
    match = { namespace = "notifications" },
    blur  = true,
})

-- ============================================================
--                        KEYBINDS
--            (identical to the i3 config)
-- ============================================================

-- --- i3 shortcuts block ---
hl.bind(mod .. " + V",      hl.dsp.exec_cmd(scripts .. "/clipboard.sh"))  -- was: clipmenu
hl.bind(mod .. " + period", hl.dsp.exec_cmd(scripts .. "/emoji.sh"))      -- was: rofi -show emoji
hl.bind(mod .. " + S",      hl.dsp.exec_cmd(scripts .. "/screenshot.sh")) -- was: flameshot gui
hl.bind(mod .. " + E",      hl.dsp.exec_cmd("hyprlock"))                  -- was: i3lock -c 000000
hl.bind(mod .. " + C",      hl.dsp.exec_cmd(scripts .. "/calc.sh"))       -- was: rofi -show calc
hl.bind(mod .. " + P",      hl.dsp.exec_cmd(scripts .. "/power.sh"))
hl.bind(mod .. " + G",      hl.dsp.exec_cmd(bin .. "/game-runner"))      -- Steam game picker

-- scratchpad
hl.bind(mod .. " + minus", hl.dsp.window.move({ workspace = "special:scratch", follow = false }))
hl.bind(mod .. " + Y",     hl.dsp.workspace.toggle_special("scratch"))

-- was: split h
hl.bind(mod .. " + U", hl.dsp.layout("togglesplit"))

-- --- core ---
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + D",      hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + F",      hl.dsp.window.fullscreen())
hl.bind(mod .. " + N",      hl.dsp.window.float({ action = "toggle" }))

-- --- focus (hjkl + arrows) ---
local dirs = { { "H", "left" }, { "J", "down" }, { "K", "up" }, { "L", "right" } }
for _, d in ipairs(dirs) do
    hl.bind(mod .. " + " .. d[1],         hl.dsp.focus({ direction = d[2] }))
    hl.bind(mod .. " + SHIFT + " .. d[1], hl.dsp.window.move({ direction = d[2] }))
end

local arrows = { { "left", "left" }, { "down", "down" }, { "up", "up" }, { "right", "right" } }
for _, a in ipairs(arrows) do
    hl.bind(mod .. " + " .. a[1],         hl.dsp.focus({ direction = a[2] }))
    hl.bind(mod .. " + SHIFT + " .. a[1], hl.dsp.window.move({ direction = a[2] }))
end

-- --- workspaces 1-10, move does NOT follow (like i3) ---
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- --- session ---
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd(scripts .. "/exit.sh"))

-- --- floating_modifier ---
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- --- audio (pactl, same as i3) ---
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +10%"),  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -10%"),  { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),  { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

-- ============================================================
--  resize submap — same l/i/k/j layout as the i3 resize mode
-- ============================================================
hl.define_submap("resize", function()
    -- l = shrink width, j = grow width, i = grow height, k = shrink height
    hl.bind("L", hl.dsp.window.resize({ x = -10, y = 0,   relative = true }), { repeating = true })
    hl.bind("J", hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }), { repeating = true })
    hl.bind("I", hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0,   y = -10, relative = true }), { repeating = true })

    -- arrows: Right shrink width, Left grow width, Up grow height, Down shrink height
    hl.bind("right", hl.dsp.window.resize({ x = -10, y = 0,   relative = true }), { repeating = true })
    hl.bind("left",  hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }), { repeating = true })
    hl.bind("up",    hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }), { repeating = true })
    hl.bind("down",  hl.dsp.window.resize({ x = 0,   y = -10, relative = true }), { repeating = true })

    hl.bind("Return",      hl.dsp.submap("reset"))
    hl.bind("Escape",      hl.dsp.submap("reset"))
    hl.bind(mod .. " + R", hl.dsp.submap("reset"))
end)

hl.bind(mod .. " + R", hl.dsp.submap("resize"))
