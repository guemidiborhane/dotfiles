local h = require("lua.helpers")
local bind = h.bind

local Meta = h.mods.Meta
local Shift = h.mods.Shift
local Control = h.mods.Control
local Alt = h.mods.Alt

local window = hl.dsp.window

bind("Escape", Meta, window.close())
bind("Q", { Meta, Shift }, window.kill())

bind("Space", { Meta, Shift }, window.float())
bind("F", Meta, window.fullscreen({ mode = "maximized" }))
bind("F", { Meta, Shift }, window.fullscreen({ mode = "fullscreen" }))
bind("P", Meta, function()
  local active_window = hl.get_active_window()
  if not active_window then return end

  if active_window.pinned then
    hl.dispatch(window.pin())
    hl.dispatch(window.float({ action = "disable" }))
  else
    hl.dispatch(window.float({ action = "enable" }))
    hl.dispatch(window.center())
    hl.dispatch(window.pin())
    hl.dispatch(window.alter_zorder({ mode = "top" }))
  end
end)

bind("mouse:272", Meta, window.drag(), { mouse = true })
bind("mouse:273", Meta, window.resize(), { mouse = true })

local delta = 20
local directions = {
  l = { key = "h", x = -delta, y = 0 },
  d = { key = "j", x = 0, y = delta },
  u = { key = "k", x = 0, y = -delta },
  r = { key = "l", x = delta, y = 0 },
}

-- focus / move / move-to-monitor
for direction, opts in next, directions do
  bind(opts.key, Meta, function()
    local action = hl.dsp.focus({ direction = direction })
    local active_workspace = h.get_active_or_special_workspace()
    if active_workspace and active_workspace.tiled_layout == "monocle" then
      local msg = (direction == "l" or direction == "u") and "cycleprev" or "cyclenext"
      action = hl.dsp.layout(msg)
    end
    hl.dispatch(action)
  end)
  bind(opts.key, { Meta, Control }, hl.dsp.window.move({ direction = direction }))
  bind(opts.key, { Meta, Control, Shift }, hl.dsp.workspace.move({ monitor = direction }))
end
bind(directions.d.key, { Meta, Shift }, window.move({ workspace = "emptym", follow = true }))

h.define_submap("R", Meta, "resize", function()
  for _, opts in next, directions do
    bind(opts.key, nil, hl.dsp.window.resize({ relative = true, x = opts.x, y = opts.y }), { repeating = true })
  end
end)

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
    name = "pip",
    match = { title = "Picture(-| )in(-| )[Pp]icture" },
    keep_aspect_ratio = true,
    move = { "monitor_w * 0.73", "monitor_h * 0.72" },
    size = { "monitor_w * 0.25", "monitor_h * 0.25" },
    float = true,
    pin = true,
    no_initial_focus = true,
    focus_on_activate = false,
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
  { class = "nz.co.mega." },
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
  { class = "terminal.popup" }
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

hl.on("window.title", function(w)
  if w.title:find("Extension:.*") then
    hl.dispatch(window.float({ action = "enable", window = w }))
    hl.dispatch(window.center({ window = w }))
    hl.dispatch(window.pin({ window = w }))
    hl.dispatch(window.alter_zorder({ mode = "top", window = w }))
  end
end)

hl.on("window.urgent", function(w)
  if not (w.class == "Bitwarden") then return end

  local active = h.get_active_or_special_workspace()
  if not active then return end

  hl.dispatch(window.move({ window = w, workspace = active.name }))
  hl.dispatch(hl.dsp.focus({ window = w }))
end)
