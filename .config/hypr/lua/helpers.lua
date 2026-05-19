local M = {}

M.mods = {
  Meta = "SUPER",
  Shift = "SHIFT",
  Control = "CTRL",
  Alt = "ALT",
}

M.apps = {
  browser = {
    key = "B",
    cmd = "zen-beta",
  },
  terminal = {
    key = "T",
    cmd = "footclient",
  }
}

function M.monitors(monitors)
  for _, monitor in ipairs(monitors) do
    local config = {}
    for k, v in pairs(monitor) do
      if k ~= "workspaces" then config[k] = v end
    end

    hl.monitor(config)

    if monitor.workspaces then
      for _, workspace in ipairs(monitor.workspaces) do
        hl.workspace_rule({
          workspace = workspace,
          monitor = monitor.output,
        })
      end
    end
  end

  hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
  })
end

M.shell = {
  cmd = function(_, cmd)
    return string.format("%s -c %q", os.getenv("SHELL"), cmd)
  end,

  exec = function(self, cmd)
    if not cmd then return end

    return hl.dsp.exec_raw(self:cmd(cmd))
  end
}

M.drun = {
  cmd = function(_, exec, slice)
    local cmd = "dr --prefix hypr"
    if slice then cmd = string.format("%s --slice=%q", cmd, slice) end

    return string.format("%s -- %s", cmd, exec)
  end,

  exec_cmd = function(self, exec, slice)
    if not exec then return end

    return hl.dsp.exec_cmd(self:cmd(exec, slice))
  end
}

M.terminal = {
  cmd = function(_, cmd, app_id)
    local command = M.apps.terminal.cmd
    if app_id then command = string.format("%s --app-id %q", command, app_id) end

    return M.drun:cmd(string.format("%s -e %s", command, cmd))
  end,

  exec = function(self, cmd, app_id)
    if not cmd then return end

    return hl.dsp.exec_raw(self:cmd(cmd, app_id))
  end
}

function M.bind(key, mod, action, flags)
  local function parts(v) return type(v) == "table" and table.concat(v, " + ") or tostring(v) end
  local mod_part = mod and (parts(mod) .. " + ") or ""
  hl.bind(mod_part .. parts(key), action, flags or {})
end

function M.define_submap(key, mod, name, func)
  M.bind(key, mod, hl.dsp.submap(name))

  hl.define_submap(name, function()
    func()
    M.bind("catchall", nil, hl.dsp.submap("reset"))
    M.bind("Escape", nil, hl.dsp.submap("reset"))
  end)
end

function M.get_active_or_special_workspace()
  local active_special = hl.get_active_special_workspace()
  local active = active_special or hl.get_active_workspace()

  return active
end

return M
