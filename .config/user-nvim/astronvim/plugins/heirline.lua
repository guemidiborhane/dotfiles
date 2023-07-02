return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    opts.statusline = require "user.plugins.configs.heirline.statusline"
    opts.winbar = require "user.plugins.configs.heirline.winbar"

    return opts
  end,
}
