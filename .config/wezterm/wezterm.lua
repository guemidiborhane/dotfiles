local wezterm = require("wezterm")
local act = wezterm.action

function Bind(m, k, action)
	return { key = k, mods = m, action = action }
end

function Tmux(m, k, bind)
	local prefix = { mods = "CTRL", key = "a" }
	bind = { key = bind or k }

	return Bind(
		m,
		k,
		act.Multiple({
			act.SendKey(prefix),
			act.SendKey(bind),
		})
	)
end

local keybinds = {
	Tmux("CTRL", "t", "c"), -- new-window
	Tmux("ALT", "f", "z"), -- resize-pane -Z
	Tmux("CTRL", "Enter", "'"), -- split-window -h # horizontal split
	Tmux("ALT", "Enter", '"'), -- split-window # vertical split
	Tmux("ALT", "t", "T"), -- fzf-make (custom script)
	Tmux("CTRL", "PageUp", "p"), -- previous-window
	Tmux("CTRL", "PageDown", "n"), -- next-window
	Tmux("CTRL", "Tab", "l"), -- last-window
	Tmux("CTRL|SHIFT", "LeftArrow", "{"), -- switch-pane -U
	Tmux("CTRL|SHIFT", "RightArrow", "}"), -- switch-pane -D
	Tmux("CTRL", "e"), -- $EDITOR
	Tmux("ALT", "e", "E"), -- yadm enter $EDITOR
	Tmux("CTRL", "b"), -- btop
	Tmux("CTRL", "n", "N"), -- sesh connect
	Tmux("CTRL", "g"), -- lazygit
	Bind("CTRL", "Backspace", act.SendString("\x17")),
	Bind("CTRL|SHIFT", "Enter", act.SplitHorizontal({ domain = "CurrentPaneDomain" })),
	Bind("ALT|SHIFT", "Enter", act.SplitVertical({ domain = "CurrentPaneDomain" })),
	Bind("CTRL|SHIFT", "T", act.SpawnTab("CurrentPaneDomain")),
	Bind("CTRL|SHIFT", "W", act.CloseCurrentTab({ confirm = true })),
	Bind("CTRL|SHIFT", "C", act.CopyTo("Clipboard")),
	Bind("CTRL|SHIFT", "V", act.PasteFrom("Clipboard")),
}

for _, dir in ipairs({ "Up", "Down", "Right", "Left" }) do
	table.insert(keybinds, Bind("ALT|SHIFT", dir .. "Arrow", act.ActivatePaneDirection(dir)))
end

for i = 1, 9 do
	table.insert(keybinds, Tmux("CTRL", tostring(i)))
end

return {
	color_scheme = "Dracula (Official)",

	font_size = 12,
	font = wezterm.font({
		family = "JetBrainsMono Nerd Font",
		weight = "Medium",
	}),
	freetype_load_target = "Normal",
	freetype_render_target = "Normal",

	disable_default_key_bindings = true,
	keys = keybinds,

	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,

	window_padding = {
		top = 0,
		left = 0,
		right = 0,
		bottom = 0,
	},
	window_decorations = "NONE",
	enable_scroll_bar = false,
	mux_enable_ssh_agent = false,
	check_for_updates = false,

	clean_exit_codes = { 130 },
	exit_behavior = "CloseOnCleanExit",
	exit_behavior_messaging = "Verbose",
	skip_close_confirmation_for_processes_named = {
		"bash",
		"sh",
		"zsh",
		"fish",
		"tmux",
		"nu",
		"cmd.exe",
		"pwsh.exe",
		"powershell.exe",
	},
	window_close_confirmation = "AlwaysPrompt",
}
