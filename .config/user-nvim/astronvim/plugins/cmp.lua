return {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  opts = {
    window = {
      completion = {
        border = "none",
        col_offset = -3,
        side_padding = 0,
      },
    },
    performance = {
      debounce = 300,
      throttle = 120,
      fetching_timeout = 100,
    },
    experimental = {
      ghost_text = true,
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      -- format = lspkind_status_ok and lspkind.cmp_format(utils.plugin_opts "lspkind.nvim") or nil,
      format = function(entry, vim_item)
        local lspkind_status_ok, lspkind = pcall(require, "lspkind")
        local utils = require "astronvim.utils"
        local lspkind_opts = utils.plugin_opts "lspkind.nvim"

        local kind = lspkind_status_ok and lspkind.cmp_format(lspkind_opts)(entry, vim_item)

        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. (strings[1] or "") .. " "
        kind.menu = "    (" .. (strings[2] or "") .. ")"

        return kind
      end,
    },
  },
}
