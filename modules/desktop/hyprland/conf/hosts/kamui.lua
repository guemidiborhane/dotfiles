-- vim: filetype=lua

local M = {}

M.monitors = {
  {
    output = "eDP-1",
    mode = "1920x1200@60",
    position = "4096x480",
    scale = 1.25,
    workspaces = { 3 },
  },
  {
    output = "desc:Seiko Epson Corporation EPSON PJ     0x01010101",
    mode = "1920x1080@60",
    position = "auto",
    scale = 1,
    mirror = "eDP-1",
  },
  {
    output = "desc:LG Electronics webOS TV 0x01010101",
    mode = "3840x2160@60",
    position = "1536x0",
    scale = 1.5,
    bitdepth = 10,
    workspaces = { 1, 2, 4 },
  },
}

M.workspace_rules = {
  ["m[eDP-1]"] = { layout = "scrolling", }
}

local v = require("lua.vars")
M.workspaces = {
  [2] = { on_created_empty = "app:helium" },
  -- named/special
  workshop = { key = "G", on_created_empty = "tmux:workshop" },
  messaging = { key = "D", clients = v.messaging_clients, },
  music = {
    key = "S",
    on_created_empty = "app:env -u DISPLAY spotify",
    clients = {
      { class = "^(spotify)$" },
    },
  },
}

return M
