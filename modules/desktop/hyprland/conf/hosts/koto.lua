-- vim: filetype=lua
local M = {}
M.monitors = {}

local leftMonitor = "DP-1"
local mainMonitor = "DP-2"
local rightMonitor = "DP-3"

local monitors = {
  [leftMonitor] = { position = "0x0", workspaces = { 3 } },
  [mainMonitor] = { workspaces = { 1, 4 } },
  [rightMonitor] = {},
}

for output, opts in next, monitors do
  table.insert(M.monitors, {
    output = output,
    mode = "2560x1440@75",
    position = opts.position or "auto-center-right",
    scale = 1.25,
    workspaces = opts.workspaces,
  })
end

M.env = {
  LIBVA_DRIVER_NAME = "nvidia",
  __GLX_VENDOR_LIBRARY_NAME = "nvidia",
  NVD_BACKEND = "direct",
}

local v = require("lua.vars")
M.workspaces = {
  [2] = {
    key = "G",
    monitor = rightMonitor,
    on_created_empty = "tmux:workshop"
  },
  [7] = {
    key = "D",
    monitor = leftMonitor,
    clients = v.messaging_clients,
  },
  [8] = {
    key = "S",
    monitor = leftMonitor,
    on_created_empty = "app:env -u DISPLAY spotify",
    clients = {
      { class = "^(spotify)$" },
    },
  },
}

return M
