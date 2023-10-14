local wezterm = require("wezterm")
local config = {}

config.check_for_updates = false
config.color_scheme = "Dracula (Official)"
config.hide_tab_bar_if_only_one_tab = true
config.default_prog = { "/usr/bin/fish", "--login" }

config.window_close_confirmation = "AlwaysPrompt"
config.enable_scroll_bar = false
config.window_padding = {
	top = 3,
	left = 3,
	right = 3,
	bottom = 3,
}

config.font_size = 13.0
config.font = wezterm.font_with_fallback({
	{
		family = "Operator Mono Book",
		weight = "Book",
	},
	"MesloLGS NF",
	{ family = "Symbols Nerd Font Mono", scale = 0.65 },
	"Noto Color Emoji",
})
config.keys = require("keys")

return config
