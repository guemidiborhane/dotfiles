local mergeTables = require("utils").mergeTables
local mappings = {}

local wezTerm = require("keys.wezterm")
local tmux = require("keys.tmux")

mergeTables(wezTerm, mappings)
mergeTables(tmux, mappings)

return mappings
