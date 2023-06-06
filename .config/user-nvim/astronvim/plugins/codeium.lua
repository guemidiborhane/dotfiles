return {
  {
    "jcdickinson/codeium.nvim",
    event = "BufEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function() require("codeium").setup {} end,
  },

  {
    "hrsh7th/nvim-cmp",
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
}
