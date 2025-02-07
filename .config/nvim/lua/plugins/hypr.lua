return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "hyprlang" } },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "hyprls",
      },
    },
  },
}
