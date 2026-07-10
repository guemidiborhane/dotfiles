local d = require("lua.dsp")
local h = require("lua.helpers")

local function delay_run(command, timeout)
  hl.timer(
    function() hl.exec_cmd(d.cmd("app:" .. command, "desktop-tray.slice")) end,
    { timeout = timeout or 2000, type = "oneshot" }
  )
end

hl.on("hyprland.start", function()
  hl.exec_cmd("systemctl --user start hyprland-session.target")
  delay_run("megasync")
  delay_run("bitwarden")
end)

hl.on("config.reloaded", function()
  h.notify("Hyprland: config reloaded", 2000, "ok")
end)
