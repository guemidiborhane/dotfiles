return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    opts.statusline = require "plugins.configs.heirline.statusline"
    opts.winbar = require "plugins.configs.heirline.winbar"

    return opts
  end,
}
