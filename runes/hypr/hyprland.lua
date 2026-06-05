local function hostname()
    local f = io.popen ("/usr/bin/hostname")
    if f == nil then
        return nil
    end
    local hostname = f:read("*a") or ""
    f:close()
    hostname = string.gsub(hostname, "\n$", "")
    return hostname
end

local hostname = hostname()

local monitor_switch = {
    ["weatherlight"] = {
        { output = "eDP-1", mode = "1920x1200", position = "0x0", scale = "1" },
        { output = "HDMI-A-1", mode = "3840x2160", position = "auto", scale = "1" },
        { output = "", mode = "highres", position = "auto", scale = "1" },
    },
    ["tolaria"] = {
        { output = "DP-3", mode = "3440x1440@144", position = "0x0", scale = "1" }
    },
    ["3QWP3T3"] = {
        { output = "eDP-1", mode = "3840x2400", position = "0x0", scale = "2" }
    },
}

local monitor_conf = monitor_switch[hostname]
if monitor_conf ~= nil then
    for _, conf in pairs(monitor_conf) do
        hl.monitor(conf)
    end
end
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hl.workspace_rule({ workspace = "special:magic", gaps_out = 300 })

if hostname == "3QWP3T3" then
    hl.workspace_rule({ workspace = "10", monitor = "eDP-1" })
end

local config_dir = os.getenv("HOME").."/.config/hypr/"

hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd(config_dir.."start-swhkd.sh")
    hl.exec_cmd(config_dir.."start-lemonbar.sh")
    hl.exec_cmd("dunst")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("changeMeWallCicle")
    if hostname == "tolaria" then
        hl.exec_cmd("shyprctl daemon")
        hl.exec_cmd("auto-start-steam")
    end
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

hl.config({
    ecosystem = {
        no_donation_nag = true
    },

    general = {
        -- See https://wiki.hyprland.org/Configuring/Variables/ for more
        border_size = 5,
        gaps_in = 3,
        gaps_out = 7,
        no_focus_fallback = true,
        locale = "en_US",

        layout = "dwindle",
        -- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false,
    },

    decoration = {
        -- See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 3,

        rounding_power = 5.0,

        blur = {
            enabled = true,
            size = 8,
            passes = 1,
            xray = false,
        },

        shadow = {
            enabled = false,
        },

        glow = {
            enabled = false,
        },

        -- motion_blur = {
        --     enabled = true,
        -- },
    },

    animations = {
        enabled = true
    },

    input = {
        kb_layout = "us",
        kb_options = "caps:escape",
        follow_mouse = 2,
        float_switch_override_focus = false,
        touchpad = {
            natural_scroll = false,
            disable_while_typing = true,
            tap_to_click = false,
            clickfinger_behavior = true,
        },
        sensitivity = 0,
    },

    group = {
        groupbar = {
            font_size = 13,
            gradients = true,
            blur = true,
        },
    },

    dwindle = {
        -- See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        preserve_split = true
    },

    misc = {
        disable_hyprland_logo = true,
        animate_mouse_windowdragging = true,
        animate_manual_resizes = true,
        -- workspace_center_on = 1, -- the last active window for that workspace
    },
})

hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "default", style = "popin" })
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = false, speed = 1, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 1, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 0.5, bezier = "default", style = "slide" })

hl.window_rule({
    name = "fix-jetbrains-popups",
    no_focus = true,
    match = {
        class = "(jetbrains-)(.*)",
        float = true,
    }
})
if hostname ~= "tolaria" then
    hl.window_rule({
        -- Ignore maximize requests from all apps. You'll probably like this.
        name  = "suppress-maximize-events",
        match = { class = ".*" },

        suppress_event = "maximize",
    })
end

local mainMod = "SUPER"

hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + CONTROL + R", hl.dsp.window.cycle_next())

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left", group_aware = true }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right", group_aware = true }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up", group_aware = true }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down", group_aware = true }))

hl.bind(mainMod .. " + CONTROL + H", hl.dsp.window.resize({ x = -20, y = 0 }))
hl.bind(mainMod .. " + CONTROL + L", hl.dsp.window.resize({ x = 20, y = 0 }))
hl.bind(mainMod .. " + CONTROL + K", hl.dsp.window.resize({ x = 0, y = -20 }))
hl.bind(mainMod .. " + CONTROL + J", hl.dsp.window.resize({ x = 0, y = 20 }))

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CONTROL + " .. key,   hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind(mainMod .. " + I", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

hl.bind(mainMod .. " + CONTROL + space", hl.dsp.group.toggle())
hl.bind(mainMod .. " + R", hl.dsp.group.next())

hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})
