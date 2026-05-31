hl.config({
  ecosystem = {
    no_update_news = true,
    no_donation_nag = true,
  },

  general = {
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
  },

  misc = {
    force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    focus_on_activate = false, -- does not affect new windows, but activate requests from windows,
    vrr = 1,
    on_focus_under_fullscreen = 2,
    disable_autoreload = true,
  },

  xwayland = { force_zero_scaling = true },
})

hl.config({
  dwindle = {
    preserve_split = true, -- You probably want this
    force_split = 2,
  },

  master = {
    orientation = "left",
  },

  scrolling = {
    fullscreen_on_one_column = true,
    column_width = 0.9,
  },
})
