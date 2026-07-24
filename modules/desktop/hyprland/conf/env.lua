local d = require("lua.dsp")
local v = require("lua.vars")
local apps = v.apps

local host_env = require("lua.helpers").get_host().env

local variables = {
  TERMINAL = d.cmd(apps.terminal.main),
  BROWSER = d.cmd(apps.browser.main),

  QT_QPA_PLATFORMTHEME = "gtk3",
  QT_WAYLAND_DISABLE_WINDOWDECORATION = "1",
  QT_QPA_PLATFORM = "wayland;xcb",
  QT_AUTO_SCREEN_SCALE_FACTOR = "auto",
  QT_SCALE_FACTOR = "1",

  XDG_SESSION_TYPE = "wayland",
  XDG_CURRENT_DESKTOP = "Hyprland",
  XDG_SESSION_DESKTOP = "Hyprland",

  GDK_BACKEND = "wayland,x11,*",
  SDL_VIDEODRIVER = "wayland",
  MOZ_ENABLE_WAYLAND = "1",
  MOZ_USE_XINPUT2 = "1",
  ELECTRON_OZONE_PLATFORM_HINT = "wayland",
  OZONE_PLATFORM = "wayland",
}

for key, value in next, host_env do
  variables[key] = value
end

local function import_env_variables()
  local envs = {
    "PATH",
    -- display
    "WAYLAND_DISPLAY",
    "DISPLAY",
    -- xdg
    "USERNAME",
    "XDG_BACKEND",
    "XDG_SESSION_ID",
    "XDG_SESSION_CLASS",
    "XDG_SEAT",
    "XDG_VTNR",
    -- hyprland
    "HYPRLAND_CMD",
    "HYPRLAND_INSTANCE_SIGNATURE",
    -- misc
    "XCURSOR_SIZE",
    -- toolkit
    "_JAVA_AWT_WM_NONREPARENTING",
    "GRIM_DEFAULT_DIR",
    -- ssh
    "SSH_AUTH_SOCK",
  }

  for key, value in next, variables do
    hl.env(key, tostring(value))
    table.insert(envs, key)
  end

  -- systemd
  hl.exec_cmd("dbus-update-activation-environment --systemd " .. table.concat(envs, " "))

  -- tmux
  for _, env in ipairs(envs) do
    local value = os.getenv(env)

    if value and value ~= "" then hl.exec_cmd(string.format("tmux setenv -g %q %q", env, value)) end
  end
end

hl.on("hyprland.start", import_env_variables)
hl.on("config.reloaded", import_env_variables)
