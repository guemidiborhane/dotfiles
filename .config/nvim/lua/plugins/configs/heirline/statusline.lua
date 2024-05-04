local get_icon = require("astroui").get_icon
local status = require "astroui.status"

return {
  status.component.mode {
    mode_text = { icon = { kind = "VimIcon", padding = { right = 1, left = 1 } } },
    padding = { right = 1 },
    hl = function() return { bg = status.hl.mode_bg(), fg = "bg", bold = true } end,
  },
  -- filetype
  status.component.file_info {
    filetype = {},
    filename = false,
    file_icon = { padding = { left = 1 } },
    file_modified = false,
    padding = { right = 1 },
    surround = {
      color = function() return { main = "command", left = "command" } end,
    },
    hl = { bg = "command", fg = "bg", bold = true },
  },
  status.component.lsp {
    lsp_progress = false,
    surround = {},
    hl = { fg = "muted_fg", bg = "bg" },
    padding = { right = 0 },
    lsp_client_names = {
      truncate = 0.15,
      icon = {
        padding = { right = 1, left = 1 },
      },
    },
  },
  status.component.fill(),
  {
    status.component.builder {
      {
        provider = get_icon "ScrollText",
      },
      hl = { bg = "bg", fg = "muted_fg" },
      padding = { right = 1 },
    },
    status.component.nav {
      percentage = false,
      hl = { bg = "bg", fg = "muted_fg" },
      scrollbar = false,
      ruler = { padding = { right = 1 }, surround = {} },
      surround = { condition = false },
    },
  },
  status.component.diagnostics {
    surround = {},
    hl = { bg = "bg" },
    padding = { right = 1, left = 0 },
  },
  status.component.git_diff {
    surround = {},
    hl = { bg = "bg", fg = "command" },
    padding = { right = 1 },
  },
  status.component.git_branch {
    hl = { fg = "bg" },
    git_branch = { icon = { kind = "GitBranch" }, padding = { left = 1, right = 1 } },
    surround = { separator = "none", color = "git_branch_fg" },
  },
}
