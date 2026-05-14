local h = require("lua.helpers")

local rules = {
  {
    name = "screen-sharing",
    match = { title = "is sharing (a window|your screen).$" },
    float = true,
    border_size = 0,
    pin = true,
    move = { "0", "monitor_h * 1-60" },
  },

  {
    name = "pip",
    match = { title = "Picture(-| )in(-| )[Pp]icture" },
    keep_aspect_ratio = true,
    move = { "monitor_w * 0.73", "monitor_h * 0.72" },
    size = { "monitor_w * 0.25", "monitor_h * 0.25" },
    float = true,
    pin = true,
    no_initial_focus = true,
  },

  {
    name = "gcr-prompter",
    match = { class = "^gcr-prompter$" },
    workspace = "1",
    stay_focused = true,
  },

  {
    match = { class = "mpv" },
    opacity = "1 override",
  },

  {
    match = { class = "zen-beta" },
    focus_on_activate = true,
  },

  {
    match = { class = "[Tt]hunar" },
    float = true,
    center = true,
    persistent_size = true,
  },

  {
    match = { class = "Bitwarden" },
    stay_focused = true,
  },

  -- Ignore maximize requests from all apps. You'll probably like this.
  {
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
  },

  -- Fix some dragging issues with XWayland
  {
    name = "fix-xwayland-drags",
    match = {
      class = "^$",
      title = "^$",
      xwayland = true,
      float = true,
      fullscreen = false,
      pin = false,
    },

    no_focus = true,
  },

  {
    name = "floating",
    match = { tag = "floatingw" },
    float = true,
    center = true,
    keep_aspect_ratio = true,
    size = { "monitor_w * 0.5", "monitor_h * 0.5" },
  },
}

function rules:add(rule)
  table.insert(self, rule)
end

local floating_windows = {
  { class = ".*(Networks).*" },
  { class = ".*(com.gabm.satty).*" },
  { class = ".*(confirm).*" },
  { class = ".*(file-png).*" },
  { class = "^(File Transfer)" },
  { class = "^(VirtualBox( Manager)?)$" },

  { title = "^Choose wallpaper(.*)$" },
  { title = "^File Upload(.*)$" },
  { title = "^Library(.*)$" },
  { title = "^Open File(.*)$" },
  { title = "^Open Folder(.*)$" },
  { title = "^Save As(.*)$" },
  { title = "^Select a File(.*)$" },

  { class = "Bitwarden" },
  { class = "GParted" },
  { class = "Localsend_app" },
  { class = "MEGAsync" },
  { class = "TeamViewer" },
  { class = "dev.noctalia.noctalia-qs" },
  { class = "io.missioncenter.MissionCenter" },

  { title = "Virtual Machine Manager" },
  { class = "blueman" },
  { class = "easyeffects" },
  { class = "io.github.nozwock.Packet" },
  { class = "nm-connection-editor" },
  { class = "nwg-look" },
  { class = "org.qbittorrent.qBittorrent" },
  { class = "qt(5|6)ct" },
  { class = "solaar" },
  { class = "udiskie" },
  { class = "xdg-desktop-portal-gtk" },
  { class = "thunderbird",                   initial_title = "Write: %(no subject%)" },
}

for _, match in ipairs(floating_windows) do
  rules:add({ match = match, tag = "+floatingw" })
end

for _, match in ipairs(h.messaging_clients) do
  rules:add({
    match = match,
    scrolling_width = 0.5,
  })
end

local no_share_windows = {
  { class = "Bitwarden" }
}
for _, match in ipairs(h.messaging_clients) do table.insert(no_share_windows, match) end
for _, match in ipairs(no_share_windows) do
  rules:add({ match = match, no_screen_share = true })
end

for _, rule in ipairs(rules) do
  hl.window_rule(rule)
end

hl.on("window.title", function(window)
  if window.title:find("Extension:.*") then
    hl.dispatch(hl.dsp.window.float({ action = "enable", window = window }))
    hl.dispatch(hl.dsp.window.center({ window = window }))
    hl.dispatch(hl.dsp.window.pin({ window = window }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top", window = window }))
  end
end)

hl.on("window.urgent", function(window)
  if not (window.class == "Bitwarden") then return end

  local active_special = hl.get_active_special_workspace()
  local active = active_special or hl.get_active_workspace()

  if not active then return end

  local target = active.name -- Ensure state
  hl.dispatch(hl.dsp.window.move({ window = window, workspace = target }))
end)
