local d = require("lua.dsp")

local M = {}

function M.get_hostname()
  local f = io.popen("/usr/bin/env hostname")
  if not f then return end

  local hostname = f:read("*a") or ""
  f:close()
  hostname = string.gsub(hostname, "\n$", "")

  return hostname
end

function M.get_active_or_special_workspace()
  local active_special = hl.get_active_special_workspace()
  local active = active_special or hl.get_active_workspace()

  return active
end

function M.notify(text, timeout, icon)
  if not text then return end

  hl.notification.create({ text = text, timeout = timeout or 5000, icon = icon })
end

function M.bind(key, mod, action, flags)
  local function parts(values) return type(values) == "table" and table.concat(values, " + ") or tostring(values) end
  local mod_part = mod and (parts(mod) .. " + ") or ""
  local resolved = type(action) == "string" and d.exec(action) or action
  hl.bind(mod_part .. parts(key), resolved, flags or {})
end

function M.define_submap(key, mod, name, func)
  M.bind(key, mod, hl.dsp.submap(name))

  hl.define_submap(name, function()
    func()
    M.bind("catchall", nil, hl.dsp.submap("reset"))
    M.bind("Escape", nil, hl.dsp.submap("reset"))
  end)
end

return M
