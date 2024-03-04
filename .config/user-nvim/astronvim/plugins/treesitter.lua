return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    -- add more things to the ensure_installed table protecting against community packs modifying it
    ensure_installed = {
      "lua",
      "ruby",
      "typescript",
      "go",
      "php",
      "yaml",
    },
  },
}
