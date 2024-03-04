return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      -- add more things to the ensure_installed table protecting against community packs modifying it
      ensure_installed = {
        "lua_ls",
        "ruby_ls",
        "emmet_ls",
        "yamlls",
      },
    },
  },

  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
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
