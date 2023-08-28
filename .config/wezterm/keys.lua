local wezTerm = require("keys.wezterm")
local tmux = require("keys.tmux")

local mappings = {}

mergeTables(wezTerm, mappings)
mergeTables(tmux, mappings)

return mappings
