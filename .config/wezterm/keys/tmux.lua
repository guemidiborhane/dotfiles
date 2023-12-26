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
		key = "g",
		mods = "CTRL",
		action = tmuxMapping({ key = "g" }),
	},

	{
		key = "Tab",
		mods = "SHIFT",
		action = tmuxMapping({ key = "l" }),
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

	{
		key = "t",
		mods = "CTRL",
		action = tmuxMapping({ key = "c" }),
	},

	{
		key = "w",
		mods = "ALT",
		action = tmuxMapping({ key = "x" }),
	},

	{
		key = "f",
		mods = "ALT",
		action = tmuxMapping({ key = "z" }),
	},
}

mergeTables(tmuxWindowMappings(), mappings)

return mappings
