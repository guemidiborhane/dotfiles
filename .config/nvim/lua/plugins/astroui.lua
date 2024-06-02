-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  { "Mofiqul/dracula.nvim" },

  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      -- change colorscheme
      colorscheme = "dracula",
      -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
      -- Icons can be configured throughout the interface
      icons = require "plugins.configs.icons",
      highlights = {
        -- dracula = require "plugins.configs.highlights.dracula",
        dracula = function()
          local colors = require("dracula").colors()

          return {
            StatusLine = { fg = colors.fg, bg = colors.bg },
            WinBar = { fg = colors.fg, bg = colors.bg },
            NoiceLspProgressSpinner = { fg = colors.yellow, bg = colors.bg },
            NoiceLspProgressTitle = { fg = colors.purple, bg = colors.bg },
            NoiceLspProgressClient = { fg = colors.green, bg = colors.bg },
          }
        end,
      },
      status = {
        attributes = {
          mode = { bold = true },
        },
        icon_highlights = {
          file_icon = {
            statusline = false,
          },
        },
        colors = require "plugins.configs.heirline.colors",
        separators = require "plugins.configs.heirline.separators",
      },
    },
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      opts.statusline = require "plugins.configs.heirline.statusline"
      opts.winbar = require "plugins.configs.heirline.winbar"
      return opts
    end,
  },
}
