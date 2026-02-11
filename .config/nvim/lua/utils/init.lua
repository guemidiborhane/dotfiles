local M = {}

M.set_keymap = function(modes, keys, action, desc, opts)
  -- Default options if none provided
  opts = opts or {}

  -- Convert single mode to table if string is provided
  if type(modes) == "string" then
    modes = { modes }
  end

  -- Ensure modes is a table
  assert(type(modes) == "table", "Modes must be a string or table")
  -- Ensure keys is a string
  assert(type(keys) == "string", "Keys must be a string")
  -- Ensure action is string or function
  assert(type(action) == "string" or type(action) == "function", "Action must be a string or function")
  -- Ensure opts is a table
  assert(type(opts) == "table", "Options must be a table")

  -- Default options
  local options = {
    silent = opts.silent or false,
    noremap = opts.noremap or true,
    expr = opts.expr or false,
    desc = desc or "",
    buffer = opts.buffer or nil,
  }

  -- Set keybind for each mode
  for _, mode in ipairs(modes) do
    if type(action) == "string" then
      -- Use nvim_set_keymap for string actions
      vim.api.nvim_set_keymap(mode, keys, action, options)
    else
      -- Use keymap.set for function actions
      vim.keymap.set(mode, keys, action, options)
    end
  end
end

return M
