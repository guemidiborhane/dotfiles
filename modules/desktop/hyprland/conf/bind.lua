local h = require("lua.helpers")
local v = require("lua.vars")
local d = require("lua.dsp")

hl.config({
  binds = {
    workspace_back_and_forth = true,
    allow_workspace_cycles = true,
    movefocus_cycles_fullscreen = false,
    movefocus_cycles_groupfirst = true,
    allow_pin_fullscreen = true,
  },
})

local bind = h.bind
local Meta, Control, Shift, Alt = v.mods.Meta, v.mods.Control, v.mods.Shift, v.mods.Alt

bind("W", { Meta, Control }, hl.dsp.group.toggle())

bind("Return", Meta, "term:s")
bind("E", { Meta, Control }, "app:thunar")
bind("Escape", Control, "app:missioncenter")
bind("A", Meta, "sh:sshkey")

for _, app in next, v.apps do
  bind(app.key, Meta, app.main)
  if app.alt then bind(app.key, { Meta, Alt }, app.alt) end
end

bind("C", Meta, "hyprpicker -a")

bind("X", { Meta, Control }, "hyprctl kill")
bind("R", { Meta, Control, Shift }, "hypres restore")
bind("R", { Meta, Shift }, "hyprctl reload")

bind("M", Meta, "popup:wiremix --tab output")
bind("B", { Meta, Shift }, "popup:bluetui")
bind("W", { Meta, Shift }, "popup:wlctl")

hl.layer_rule({ match = { namespace = "vicinae" }, blur = true, ignore_alpha = 0 })
d:add("vic", function(cmd) return "vicinae vicinae://" .. cmd end)
bind("Space", Meta, "vic:toggle")
bind("Grave", Meta, "vic:launch/wm/switch-windows")
bind("Space", { Control, Shift }, "vic:launch/core/search-emojis")
bind("H", { Control, Alt }, "vic:launch/clipboard/history")

d:add("noc", function(cmd) return "noctalia msg " .. cmd end)
bind("Print", nil, "noc:screenshot-region")
bind("Print", Shift, "noc:screenshot-fullscreen")
bind(0, Meta, "noc:panel-toggle session")
bind("Z", Alt, "noc:panel-toggle control-center notifications")
bind("L", { Alt, Shift }, function()
  hl.dispatch(d.exec("noc:media pause"))
  hl.dispatch(d.exec("noc:session lock"))
  hl.timer(function() hl.dispatch(hl.dsp.dpms({ action = "disable" })) end, { timeout = 500, type = "oneshot" })
end, { release = true })
h.define_submap("W", Meta, "wallpaper", function()
  bind("C", nil, "noc:panel-toggle wallpaper")
  bind("R", nil, "noc:wallpaper-random")
end)

local special_keys = {
  MonBrightnessUp = { ipc = "brightness-up all", repeating = true },
  MonBrightnessDown = { ipc = "brightness-down all", repeating = true },
  AudioRaiseVolume = { ipc = "volume-up", repeating = true },
  AudioLowerVolume = { ipc = "volume-down", repeating = true },
  AudioMute = { ipc = "volume-mute", repeating = true },
  AudioMicMute = { ipc = "mic-mute", repeating = true },
  AudioNext = { ipc = "media next" },
  AudioPrev = { ipc = "media previous" },
  AudioPause = { ipc = "media toggle" },
  AudioPlay = { ipc = "media toggle" },
}
for key, entry in next, special_keys do
  bind("XF86" .. key, nil, "noc:" .. entry.ipc, { locked = true, repeating = entry.repeating or false })
end
bind("XF86AudioNext", Shift, "noc:media previous", { locked = true })

h.define_submap("V", Meta, "vpn", function()
  bind("c", nil, "sh:vpn connect")
  bind("d", nil, "sh:vpn disconnect")
  bind("r", nil, "sh:vpn reconnect")
end)
