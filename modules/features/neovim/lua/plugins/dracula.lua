return {
  -- add dracula
  {
    "Mofiqul/dracula.nvim",
    opts = function(_, opts)
      local dracula = require("dracula")
      local colors = dracula.colors()

      return {
        lualine_bg_color = colors.bg,
        overrides = {
          StatusLine = { bg = colors.bg, fg = colors.fg },
        },
      }
    end,
  },

  -- Configure LazyVim to load dracula
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "dracula-nvim",
      },
    },
  },
}
