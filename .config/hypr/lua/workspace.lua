local h = require("lua.helpers")

h.messaging_clients = {
  { class = "thunderbird" },
  { class = "org.telegram.desktop" },
  { class = "signal" },
  { class = "vesktop" },
}

local Meta = h.mods.Meta
local Shift = h.mods.Shift
local Control = h.mods.Control
local Alt = h.mods.Alt

local function open_tmux_session_cmd(name)
  local cmd = string.format("tmux new-session -As %q", name)
  return h.terminal:cmd(cmd, name .. "-session")
end

local function drun_cmd(cmd) return h.drun:cmd(cmd) end
local workspaces = {
  [1] = { on_created_empty = drun_cmd(h.apps.browser.cmd) },
  [2] = { on_created_empty = h.terminal:cmd("s") },
  [3] = {
    on_created_empty = open_tmux_session_cmd("monitors"),
    clients = { { class = "monitors-session" } }
  },

  -- named/special
  workshop = { key = "G", on_created_empty = open_tmux_session_cmd("workshop") },
  messaging = {
    key = "D",
    clients = h.messaging_clients,
  },
  music = {
    key = "S",
    on_created_empty = drun_cmd("spotify"),
    clients = {
      { class = "^(spotify)$" },
    },
  },
}

local special_prefix = "special:"
local function smart_focus(workspace, close_all)
  return function()
    local active = hl.get_active_special_workspace()
    local is_special = string.match(tostring(workspace), special_prefix)
    local function special_dispatcher(name) return hl.dsp.workspace.toggle_special(name:gsub(special_prefix, "")) end

    if active and not (active.name == workspace) then
      -- close whatever special is open
      hl.dispatch(special_dispatcher(active.name))
      -- special->special: close only, don't open target (smart toggle)
      if close_all and is_special then return end
      -- special->numbered: fall through and focus the target
    end

    local dispatcher
    if is_special then
      dispatcher = special_dispatcher(workspace)
    else
      dispatcher = hl.dsp.focus({ workspace = workspace })
    end

    hl.dispatch(dispatcher)
  end
end
local function workspace_rules(name, mod, i)
  local workspace = string.gsub(tostring(name), special_prefix, "")
  local opts = workspaces[tonumber(workspace) or workspace]
  local key = (opts and opts.key) or i or workspace

  h.bind(key, mod, smart_focus(name, true))
  h.bind(key, { mod, Alt }, smart_focus(name, false))
  h.bind(key, { mod, Shift }, hl.dsp.window.move({ workspace = name, follow = true }))
  h.bind(key, { mod, Control }, hl.dsp.window.move({ workspace = name, follow = false }))

  if not opts then return end

  if opts.on_created_empty then
    hl.workspace_rule({
      workspace = tostring(name),
      on_created_empty = opts.on_created_empty,
    })
  end

  if opts.clients then
    for _, match in ipairs(opts.clients) do
      hl.window_rule({
        match = match,
        workspace = name .. " silent",
      })
    end
  end
end

local function numbered_workspaces(mod, i, offset)
  local name = i + (offset or 0)
  workspace_rules(name, mod, i)
end
for i = 1, 9 do
  numbered_workspaces(Meta, i)    -- 1-9
  numbered_workspaces(Alt, i, 10) -- 11-19
end

for name, _ in next, workspaces do
  if type(name) == "string" then
    local workspace = special_prefix .. name

    workspace_rules(workspace, Meta)
    hl.workspace_rule({ workspace = workspace, layout = "scrolling" })
  end
end

h.bind("T", Alt, function()
  local layouts = { "dwindle", "scrolling", "monocle" }

  local active = h.get_active_or_special_workspace()
  if not active then return end

  local current = active.tiled_layout
  local next_layout = layouts[1] -- fallback if current isn't in the list

  for i, name in ipairs(layouts) do
    if name == current then
      next_layout = layouts[(i % #layouts) + 1]
      break
    end
  end

  local target = active.name

  hl.workspace_rule({ workspace = target, layout = next_layout })
  hl.notification.create({ timeout = 2000, text = next_layout })
end)

h.bind("Tab", Meta, hl.dsp.focus({ workspace = "m+1" }))
h.bind("Tab", { Meta, Shift }, hl.dsp.focus({ workspace = "m-1" }))
h.bind("mouse_up", Meta, hl.dsp.focus({ workspace = "m-1" }))
h.bind("mouse_down", Meta, hl.dsp.focus({ workspace = "m+1" }))

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical", action = "special", workspace_name = "workshop" })
