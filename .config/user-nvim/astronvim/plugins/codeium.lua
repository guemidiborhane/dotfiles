return {
  {
    "hrsh7th/nvim-cmp",
    commit = "6c84bc75c64f778e9f1dcb798ed41c7fcb93b639",
    dependencies = {
      "jcdickinson/codeium.nvim",
    },
    opts = function(_, opts)
      local cmp = require "cmp"
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "codeium", priority = 2500 },
      }))

      return opts
    end,
  },

  {
    "jcdickinson/codeium.nvim",
    event = "User AstroFile",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function() require("codeium").setup {} end,
  },
}
