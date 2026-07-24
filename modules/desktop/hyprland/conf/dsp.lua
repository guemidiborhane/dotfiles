local v = require("lua.vars")

local M = {}

M.dispatchers = {
  add = function(self, prefix, handler)
    local p = prefix .. ":"
    if self.handlers[p] then error(prefix .. " handler prefix already registered") end

    self.handlers[p] = handler
  end,

  get = function(self, cmd, opts)
    for prefix, d in next, self.handlers do
      if cmd:sub(1, #prefix) == prefix then
        return d(cmd:sub(#prefix + 1), opts)
      end
    end

    return cmd
  end,
}

function M.cmd(cmd, opts)
  return M.dispatchers:get(cmd, opts)
end

function M.exec(cmd, opts)
  return hl.dsp.exec_raw(M.cmd(cmd, opts))
end

M.dispatchers.handlers = {
  ["sh:"] = function(cmd, _)
    return string.format("%s -c %q", os.getenv("SHELL"), cmd)
  end,

  ["app:"] = function(exec, slice)
    local cmd = "hydrun --prefix hypr"
    if slice then cmd = string.format("%s --slice=%q", cmd, slice) end

    return string.format("%s -- %s", cmd, exec)
  end,

  ["term:"] = function(cmd, app_id)
    local command = v.apps.terminal.main
    if app_id then command = string.format("%s --app-id %q", command, app_id) end

    return string.format("%s -e %s", M.dispatchers:get(command), cmd)
  end,

  ["popup:"] = function(cmd, _)
    return M.dispatchers:get("term:" .. cmd, "terminal.popup")
  end,

  ["tmux:"] = function(session_name)
    local cmd = string.format("tmux new-session -As %q", session_name)
    return M.dispatchers:get("term:" .. cmd, session_name .. "-session")
  end
}

return M
