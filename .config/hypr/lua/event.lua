local h = require("lua.helpers")

hl.on("hyprland.start", function()
  local function tray_run(command)
    hl.timer(
      function() hl.exec_cmd(h.drun:cmd(command, "desktop-tray.slice")) end,
      { timeout = 2000, type = "oneshot" }
    )
  end

  tray_run("megasync")
  tray_run("bitwarden")

  hl.exec_cmd("systemctl --user start --wait hypr-session.target")
end)

hl.on("config.reloaded", function()
  hl.notification.create({ text = "Hyprland: config reloaded", timeout = 2000, icon = "ok" })
end)
