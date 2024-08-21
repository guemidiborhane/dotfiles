local map = require("utils").tmuxMapping

return {
	{
		key = "p",
		mods = "ALT",
		action = map({ key = "T" }),
	},

	{
		key = "Enter",
		mods = "CTRL",
		action = map({ key = "'" }),
	},

	{
		key = "Enter",
		mods = "ALT",
		action = map({ key = '"' }),
	},

	{
		key = "t",
		mods = "CTRL",
		action = map({ key = "c" }),
	},

	{
		key = "w",
		mods = "ALT",
		action = map({ key = "x" }),
	},

	{
		key = "f",
		mods = "ALT",
		action = map({ key = "z" }),
	},

	{
		key = "`",
		mods = "ALT",
		action = map({ key = "f" }),
	},

	{
		key = "LeftArrow",
		mods = "CTRL|SHIFT",
		action = map({ key = "{" }),
	},

	{
		key = "RightArrow",
		mods = "CTRL|SHIFT",
		action = map({ key = "}" }),
	},

	{
		key = "PageUp",
		mods = "CTRL",
		action = map({ key = "p" }),
	},

	{
		key = "PageDown",
		mods = "CTRL",
		action = map({ key = "n" }),
	},

	{
		key = "1",
		mods = "CTRL",
		action = map({ key = "1" }),
	},

	{
		key = "2",
		mods = "CTRL",
		action = map({ key = "2" }),
	},

	{
		key = "3",
		mods = "CTRL",
		action = map({ key = "3" }),
	},
}
