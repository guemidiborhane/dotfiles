local h = require("lua.helpers")

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

local Meta = h.mods.Meta
local Shift = h.mods.Shift
local Control = h.mods.Control
local Alt = h.mods.Alt

local exec_cmd = hl.dsp.exec_cmd

bind("W", Meta, hl.dsp.group.toggle())

local function drun(command) return h.drun:exec_cmd(command) end
bind("Return", Meta, h.terminal:exec("s"))
bind("E", { Meta, Control }, drun("thunar"))
bind("Escape", Control, drun("missioncenter"))
bind("A", Meta, h.shell:exec("sshkey"))

for _, app in next, h.apps do
  bind(app.key, Meta, drun(app.cmd))
end

bind("C", Meta, exec_cmd("hyprpicker -a"))

bind("Print", nil, exec_cmd("capture -m region"))
bind("Print", Shift, exec_cmd("capture"))

bind("X", { Meta, Control }, exec_cmd("hyprctl kill"))
bind("R", { Meta, Control, Shift }, exec_cmd("hypres restore"))
bind("R", { Meta, Shift }, exec_cmd("hyprctl reload"))

local terminal_class = "terminal.popup"
hl.window_rule({ match = { class = terminal_class }, tag = "+floatingw" })
local function popup_terminal(cmd) return h.terminal:exec(cmd, terminal_class) end
bind("E", Meta, popup_terminal("yazi ~"))
bind("M", Meta, popup_terminal("wiremix --tab output"))
bind("B", { Meta, Shift }, popup_terminal("bluetui"))
bind("W", { Meta, Shift }, popup_terminal("wlctl"))

hl.layer_rule({ match = { namespace = "vicinae" }, blur = true, ignore_alpha = 0 })
local function vicinae(deep_link) return exec_cmd("vicinae vicinae://" .. deep_link) end
bind("Space", Meta, vicinae("toggle"))
bind("Grave", Meta, vicinae("launch/wm/switch-windows"))
bind("Space", { Control, Shift }, vicinae("launch/core/search-emojis"))
bind("H", { Control, Alt }, vicinae("launch/clipboard/history?toggle=true"))

local function noctalia(ipc) return exec_cmd("noctalia-shell ipc call " .. ipc) end
bind(0, Meta, noctalia("sessionMenu toggle"))
bind("Z", Alt, noctalia("notifications toggleHistory"))
bind("L", { Alt, Shift }, function()
  hl.dispatch(noctalia("media pause"))
  hl.dispatch(noctalia("lockScreen lock"))
  hl.timer(function() hl.dispatch(hl.dsp.dpms({ action = "disable" })) end, { timeout = 500, type = "oneshot" })
end, { release = true })
bind("W", { Meta, Control }, function()
  local monitors = hl.get_monitors()
  for _, monitor in ipairs(monitors) do
    hl.dispatch(noctalia("wallpaper random " .. monitor.name))
  end
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
  bind("XF86" .. key, nil, noctalia(entry.ipc), { locked = true, repeating = entry.repeating or false })
end
bind("XF86AudioNext", Shift, noctalia("media previous"), { locked = true })

h.define_submap("V", Meta, "vpn", function()
  bind("c", nil, exec_cmd("vpn connect"))
  bind("d", nil, exec_cmd("vpn disconnect"))
  bind("r", nil, exec_cmd("vpn reconnect"))
end)
