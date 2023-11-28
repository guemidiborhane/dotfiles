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
		key = "RightArrow",
		mods = "ALT",
		action = tmuxMapping({ key = "RightArrow", mods = "CTRL" }),
	},

	{
		key = "LeftArrow",
		mods = "ALT",
		action = tmuxMapping({ key = "LeftArrow", mods = "CTRL" }),
	},
	{
		key = "UpArrow",
		mods = "ALT",
		action = tmuxMapping({ key = "UpArrow", mods = "CTRL" }),
	},
	{
		key = "DownArrow",
		mods = "ALT",
		action = tmuxMapping({ key = "DownArrow", mods = "CTRL" }),
	},
}

mergeTables(tmuxWindowMappings(), mappings)

return mappings
