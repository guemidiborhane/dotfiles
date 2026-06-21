local d = require("lua.dsp")
local h = require("lua.helpers")

local function delay_run(command, timeout)
  hl.timer(
    function() hl.exec_cmd(d.cmd("app:" .. command, "desktop-tray.slice")) end,
    { timeout = timeout or 2000, type = "oneshot" }
  )
end

hl.on("hyprland.start", function()
  delay_run("megasync")
  delay_run("bitwarden")

  for _, command in ipairs({ "stop", "start" }) do
    hl.exec_cmd(string.format("systemctl --user %s hyprland-session.target", command))
  end
end)

hl.on("config.reloaded", function()
  h.notify("Hyprland: config reloaded", 2000, "ok")
end)
