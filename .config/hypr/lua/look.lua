local background = "rgb(282A36)"
local foreground = "rgb(F8F8F2)"
local selection = "rgb(44475A)"
local comment = "rgb(6272A4)"
local red = "rgb(FF5555)"
local orange = "rgb(FFB86C)"
local yellow = "rgb(F1FA8C)"
local green = "rgb(50FA7B)"
local purple = "rgb(BD93F9)"
local cyan = "rgb(8BE9FD)"
local pink = "rgb(FF79C6)"

local function gset(property, value)
  hl.exec_cmd(string.format("gsettings set org.gnome.desktop.interface %q %q", property, value))
end

gset("gtk-theme", "Dracula")
gset("icon-theme", "kora")
gset("font-name", "Cantarell 11")
gset("monospace-font-name", "MonaspiceAr Nerd Font Propo 11")
gset("color-scheme", "prefer-dark")
gset("accent-color", purple)

local cursor = {
  theme = "Banana",
  size = "40",
}

hl.env("XCURSOR_THEME", cursor.theme)
hl.env("XCURSOR_SIZE", cursor.size)
hl.env("HYPRCURSOR_SIZE", cursor.size)
gset("cursor-theme", cursor.theme)
gset("cursor-size", cursor.size)
hl.config({ cursor = { sync_gsettings_theme = true } })

local gaps = 5
local border_colors = {
  active = purple,
  inactive = selection,
}

hl.config({
  misc = { font_family = "MonaSpiceAr Nerd Font Propo" },

  general = {
    gaps_in = gaps,
    gaps_out = gaps * 2,
    gaps_workspaces = 0,

    border_size = 2,
    col = {
      active_border = border_colors.active,
      inactive_border = border_colors.inactive,
      nogroup_border = background,
      nogroup_border_active = border_colors.active,
    },
  },

  decoration = {
    rounding = gaps,

    active_opacity = 1.0,
    inactive_opacity = 0.95,

    dim_inactive = true,
    dim_strength = 0.1,

    shadow = {
      enabled = true,
      color = "rgba(1E202966)",
      render_power = 3,
      range = 60,
      offset = "1 2",
      scale = 0.97,
    },

    blur = {
      enabled = true,
      size = 8,
      passes = 3,
      ignore_opacity = false,
      brightness = 1.0,
      xray = false,
      vibrancy = 0.3,
      vibrancy_darkness = 0.05,
      contrast = 1.0,
      popups = true,
      new_optimizations = true,
      noise = 0,
    },
  },

  group = {
    col = {
      border_active = border_colors.active,
      border_inactive = border_colors.inactive,
    },

    groupbar = {
      enabled = true,
      render_titles = true,
      height = 20,
      gradients = true,
      font_size = 14,
      text_color = foreground,
      gaps_in = 0,
      gaps_out = gaps * -1,
      gradient_rounding = gaps,
      keep_upper_gap = false,
      indicator_height = 0,
      col = {
        active = border_colors.active,
        inactive = border_colors.inactive,
      },
    },
  },
})

hl.curve("instantDecel", { type = "bezier", points = { { 0.2, 0.9 }, { 0.3, 1 } } })
hl.curve("quickIn", { type = "bezier", points = { { 0.4, 0 }, { 0.8, 0.2 } } })
hl.curve("balanced", { type = "bezier", points = { { 0.6, 0 }, { 0.2, 1 } } })

hl.config({ animations = { enabled = true } })
hl.animation({ leaf = "windows", enabled = true, speed = 1.05, bezier = "instantDecel", style = "popin 96%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "quickIn", style = "popin 96%" })
hl.animation({ leaf = "border", enabled = true, speed = 1.1, bezier = "instantDecel" })
hl.animation({ leaf = "fade", enabled = true, speed = 1.05, bezier = "instantDecel" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.35, bezier = "balanced", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 1.25, bezier = "instantDecel", style = "slidevert" })

hl.window_rule({ match = { xwayland = true }, border_color = cyan })
