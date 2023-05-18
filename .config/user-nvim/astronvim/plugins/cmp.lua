return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "jcdickinson/codeium.nvim",
    },
    opts = function(_, opts)
      local cmp = require "cmp"
      opts.sources = cmp.config.sources {
        { name = "codeium",  priority = 1250 },
        { name = "emmet",    priority = 1000 },
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip",  priority = 750 },
        { name = "buffer",   priority = 500 },
        { name = "path",     priority = 250 },
      }

      return opts
    end,
  },

  {
    "onsails/lspkind.nvim",
    opts = {
      mode = "symbol",
      symbol_map = {
        Array = "󰅪",
        Boolean = "⊨",
        Class = "󰌗",
        Constructor = "",
        Key = "󰌆",
        Namespace = "󰅪",
        Null = "NULL",
        Number = "#",
        Object = "󰀚",
        Package = "󰏗",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "󰀬",
        TypeParameter = "󰊄",
        Unit = "",
        Codeium = "",
        Emmet = "",
      },
    },
    enabled = vim.g.icons_enabled,
    config = require "plugins.configs.lspkind",
  },
}
