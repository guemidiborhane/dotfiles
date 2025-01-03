---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    -- NOTE: additional parser
    { "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
  },
  build = ":TSUpdate",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "lua",
      "vim",
      "make",
      "ruby",
      "php",
      "typescript",
      "javascript",
      "json",
      "dockerfile",
      "go",
      "scss",
      "css",
      "html",
    })
  end,
}
