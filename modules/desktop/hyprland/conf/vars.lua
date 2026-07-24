local M = {
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
    { class = "legcord" },
  }
}

M.handlers = {
  sh = function(cmd, _, _)
    return string.format("%s -c %q", os.getenv("SHELL"), cmd)
  end,

  app = function(exec, slice, _)
    local cmd = "hydrun --prefix hypr"
    if slice then cmd = string.format("%s --slice=%q", cmd, slice) end

    return string.format("%s -- %s", cmd, exec)
  end,

  term = function(cmd, app_id, dispatch)
    local command = M.apps.terminal.main
    if app_id then command = string.format("%s --app-id %q", command, app_id) end

    return string.format("%s -e %s", dispatch:get(command), cmd)
  end,

  popup = function(cmd, _, dispatch)
    return dispatch:get("term:" .. cmd, "terminal.popup")
  end,

  tmux = function(session_name, _, dispatch)
    local cmd = string.format("tmux new-session -As %q", session_name)
    return dispatch:get("term:" .. cmd, session_name .. "-session")
  end,
}

return M
