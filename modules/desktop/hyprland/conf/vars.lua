return {
  mods = {
    Meta = "SUPER",
    Shift = "SHIFT",
    Control = "CTRL",
    Alt = "ALT",
  },

  apps = {
    browser = {
      key = "B",
      main = "app:zen-beta",
      alt = "app:helium",
    },
    terminal = {
      key = "T",
      main = "app:footclient",
      alt = "app:kitty",
    },
    file_manager = {
      key = "E",
      main = "popup:yazi ~",
      alt = "app:thunar",
    }
  },

  messaging_clients = {
    { class = "thunderbird" },
    { class = "org.telegram.desktop" },
    { class = "signal" },
    { class = "vesktop" },
  }
}
