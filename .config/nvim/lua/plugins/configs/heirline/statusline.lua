local get_icon = require("astroui").get_icon
local status = require "astroui.status"

return {
  status.component.mode {
    mode_text = { icon = { kind = "VimIcon", padding = { right = 1, left = 1 } } },
    padding = { right = 1 },
    hl = function() return { bg = status.hl.mode_bg(), fg = "bg", bold = true } end,
    surround = {
      separator = "none",
    },
  },
  status.component.builder {
    { provider = "" },
    surround = {
      separator = "right",
      color = function() return { main = status.hl.mode_bg(), right = "command" } end,
    },
  },
  -- filetype
  status.component.file_info {
    filetype = {},
    filename = false,
    file_icon = { padding = { left = 0 } },
    file_modified = false,
    padding = { right = 1 },
    surround = {
      separator = "left_inner",
      -- color = function() return { main = status.hl.mode_bg(), left = "command" } end,
      color = function() return { main = "command", left = "command" } end,
    },
    hl = { bg = "command", fg = "bg", bold = true },
  },
  status.component.builder {
    { provider = "" },
    surround = { separator = "right", color = "command" },
  },
  status.component.lsp {
    lsp_progress = false,
    surround = { separator = "none" },
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
      surround = { separator = "none" },
      padding = { right = 1 },
    },
    status.component.nav {
      percentage = false,
      hl = { bg = "bg", fg = "muted_fg" },
      scrollbar = false,
      ruler = { padding = { right = 1 }, surround = { separator = "none" } },
      surround = { separator = "none", condition = false },
    },
  },
  status.component.diagnostics {
    surround = { separator = "none" },
    hl = { bg = "bg" },
    padding = { right = 0, left = 0 },
  },
  status.component.builder {
    { provider = "" },
    surround = { separator = "left", color = "bg" },
  },
  status.component.git_diff {
    surround = { separator = "none" },
    hl = { bg = "bg", fg = "command" },
    padding = { right = 1 },
  },
  status.component.git_branch {
    hl = { bg = "git_branch_fg", fg = "bg" },
    git_branch = { icon = { kind = "GitBranch" }, padding = { left = 1, right = 1 } },
    surround = { separator = "left", color = "git_branch_fg" },
  },
}
