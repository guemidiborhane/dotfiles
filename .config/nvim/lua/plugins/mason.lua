return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "ruby_ls",
        "emmet_ls",
        "yamlls",
      },
    },
  },

  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = {
        "rubocop",
        "stylua",
        "jq",
        "prettierd",
        "htmlbeautifier",
        "yamllint",
        "stylelint",
      },
      automatic_installation = true,
    },
  },
}
