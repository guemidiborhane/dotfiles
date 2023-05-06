local on_attach = require('plugins.configs.lspconfig').on_attach
local capabilities = require('plugins.configs.lspconfig').capabilities

local lspconfig = require 'lspconfig'

lspconfig.solargraph.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {'ruby'},
  root_dir = lspconfig.util.root_pattern("Gemfile", ".git")
})

