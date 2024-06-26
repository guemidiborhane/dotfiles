local utils = require("utils")

local mappings = {
	{
		key = "p",
		mods = "ALT",
		action = tmuxMapping({ key = "T" }),
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

	{
		key = "`",
		mods = "ALT",
		action = tmuxMapping({ key = "f" }),
	},

	{
		key = "LeftArrow",
		mods = "CTRL|SHIFT",
		action = tmuxMapping({ key = "{" }),
	},

	{
		key = "RightArrow",
		mods = "CTRL|SHIFT",
		action = tmuxMapping({ key = "}" }),
	},
}

mergeTables(tmuxWindowMappings(), mappings)

return mappings
