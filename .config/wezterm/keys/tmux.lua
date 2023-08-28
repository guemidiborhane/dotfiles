local utils = require("utils")

local mappings = {
	{
		key = "p",
		mods = "ALT",
		action = tmuxMapping({ key = "T" }),
	},

	{
		key = "e",
		mods = "CTRL",
		action = tmuxMapping({ key = "e" }),
	},

	{
		key = "Tab",
		mods = "SHIFT",
		action = tmuxMapping({ key = "n" }),
	},

	{
		key = "Enter",
		mods = "CTRL",
		action = tmuxMapping({ key = "'" }),
	},

	{
		key = "Enter",
		mods = "ALT",
		action = tmuxMapping({ key = '"' }),
	},
}

mergeTables(tmuxWindowMappings(), mappings)

return mappings
