local v = require("lua.vars")

local M = {
  handlers = {},
  add = function(self, prefix, handler)
    local p = prefix .. ":"
    if self.handlers[p] then error(prefix .. " handler prefix already registered") end

    self.handlers[p] = handler
  end,

  get = function(self, cmd, opts)
    for prefix, d in next, self.handlers do
      if cmd:sub(1, #prefix) == prefix then
        return d(cmd:sub(#prefix + 1), opts, self)
      end
    end

    return cmd
  end,
}

function M.cmd(cmd, opts)
  return M:get(cmd, opts)
end

function M.exec(cmd, opts)
  return hl.dsp.exec_raw(M.cmd(cmd, opts))
end

for prefix, handler in next, v.handlers do
  M:add(prefix, handler)
end

return M
