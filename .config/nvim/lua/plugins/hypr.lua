return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "hyprlang" } },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "hyprls",
      },
    },
  },
}
