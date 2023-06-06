return {
  "hrsh7th/nvim-cmp",
  opts = {
    window = {
      completion = {
        -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:none",
        border = "none",
        col_offset = -3,
        side_padding = 0,
      },
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
