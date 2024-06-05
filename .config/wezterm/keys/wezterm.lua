local action = require("wezterm").action

return {
	{
		key = "Tab",
		mods = "CTRL",
		action = action.SendKey({ key = "Tab", mods = "CTRL" }),
	},

	{
		key = "Backspace",
		mods = "CTRL",
		action = action.SendString("\x17"),
	},

	{
		key = "Enter",
		mods = "CTRL|SHIFT",
		action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	{
		key = "Enter",
		mods = "ALT|SHIFT",
		action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	{
		key = "e",
		mods = "ALT",
		action = action.SendKey({ key = "t", mods = "CTRL" }),
	},
}
