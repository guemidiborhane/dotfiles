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
		key = "RightArrow",
		mods = "ALT|SHIFT",
		action = action.ActivatePaneDirection("Right"),
	},

	{
		key = "LeftArrow",
		mods = "ALT|SHIFT",
		action = action.ActivatePaneDirection("Left"),
	},

	{
		key = "UpArrow",
		mods = "ALT|SHIFT",
		action = action.ActivatePaneDirection("Up"),
	},

	{
		key = "DownArrow",
		mods = "ALT|SHIFT",
		action = action.ActivatePaneDirection("Down"),
	},

	{
		key = "e",
		mods = "ALT",
		action = action.SendKey({ key = "t", mods = "CTRL" }),
	},
}
