local h = require("lua.helpers")
local v = require("lua.vars")
local d = require("lua.dsp")

local bind = h.bind
local Meta, Control, Shift, Alt = v.mods.Meta, v.mods.Control, v.mods.Shift, v.mods.Alt

local host_rules = h.get_host().workspace_rules
for selector, rule in next, host_rules do
  local r = {}
  for k, vv in next, rule do r[k] = vv end
  r.workspace = selector
  hl.workspace_rule(r)
end

local workspaces = {
  [1] = { on_created_empty = v.apps.browser.main },
  [3] = {
    on_created_empty = "tmux:monitors",
    clients = {
      { class = "monitors-session" }
    }
  },
}

local host_workspaces = h.get_host().workspaces
for name, workspace in next, host_workspaces do
  workspaces[name] = workspace
end

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

  bind(key, mod, smart_focus(name, true))
  bind(key, { mod, Alt }, smart_focus(name, false))
  bind(key, { mod, Shift }, hl.dsp.window.move({ workspace = name, follow = true }))
  bind(key, { mod, Control }, hl.dsp.window.move({ workspace = name, follow = false }))

  if not opts then return end

  if opts.on_created_empty then
    hl.workspace_rule({
      workspace = tostring(name),
      on_created_empty = d.cmd(opts.on_created_empty),
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

  if opts.monitor then
    hl.workspace_rule({
      workspace = tostring(name),
      monitor = opts.monitor,
    })
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

bind("T", { Meta, Shift }, function()
  local layouts = { "dwindle", "master", "scrolling", "monocle" }

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

bind("Tab", Meta, hl.dsp.focus({ workspace = "m+1" }))
bind("Tab", { Meta, Shift }, hl.dsp.focus({ workspace = "m-1" }))
bind("mouse_up", Meta, hl.dsp.focus({ workspace = "m-1" }))
bind("mouse_down", Meta, hl.dsp.focus({ workspace = "m+1" }))

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical", action = "special", workspace_name = "workshop" })
