-- vim: filetype=lua

local h = require("lua.helpers")
local monitors = require("lua.monitors." .. h.getHostname())

for _, monitor in ipairs(monitors) do
  local config = {}
  for k, v in pairs(monitor) do
    if k ~= "workspaces" then config[k] = v end
  end

  hl.monitor(config)

  if monitor.workspaces then
    for _, workspace in ipairs(monitor.workspaces) do
      hl.workspace_rule({
        workspace = workspace,
        monitor = monitor.output,
      })
    end
  end
end

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
})
