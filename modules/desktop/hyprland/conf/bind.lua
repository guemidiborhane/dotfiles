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

bind("Print", nil, "capture -m region")
bind("Print", Shift, "capture")

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

d:add("noc", function(cmd) return "noctalia-shell ipc call " .. cmd end)
bind(0, Meta, "noc:sessionMenu toggle")
bind("Z", Alt, "noc:notifications toggleHistory")
bind("L", { Alt, Shift }, function()
  hl.dispatch(d.exec("noc:media pause"))
  hl.dispatch(d.exec("noc:lockScreen lock"))
  hl.timer(function() hl.dispatch(hl.dsp.dpms({ action = "disable" })) end, { timeout = 500, type = "oneshot" })
end, { release = true })
h.define_submap("W", Meta, "wallpaper", function()
  bind("C", nil, "noc:wallpaper toggle")
  bind("R", nil, function()
    local monitors = hl.get_monitors()
    for _, monitor in ipairs(monitors) do
      hl.dispatch(d.exec("noc:wallpaper random " .. monitor.name))
    end
  end)
end)

local special_keys = {
  MonBrightnessUp = { ipc = "brightness increase", repeating = true },
  MonBrightnessDown = { ipc = "brightness decrease", repeating = true },
  AudioRaiseVolume = { ipc = "volume increase", repeating = true },
  AudioLowerVolume = { ipc = "volume decrease", repeating = true },
  AudioMute = { ipc = "volume muteOutput", repeating = true },
  AudioMicMute = { ipc = "volume muteInput", repeating = true },
  AudioNext = { ipc = "media next" },
  AudioPrev = { ipc = "media previous" },
  AudioPause = { ipc = "media playPause" },
  AudioPlay = { ipc = "media playPause" },
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
