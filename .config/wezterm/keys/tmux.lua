local utils = require("utils")

local mappings = {
	{
		key = "p",
		mods = "ALT",
		action = tmuxMapping({ key = "T" }),
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

	{
		key = "PageUp",
		mods = "CTRL",
		action = tmuxMapping({ key = "p" }),
	},

	{
		key = "PageDown",
		mods = "CTRL",
		action = tmuxMapping({ key = "n" }),
	},
}

mergeTables(tmuxWindowMappings(), mappings)

return mappings
