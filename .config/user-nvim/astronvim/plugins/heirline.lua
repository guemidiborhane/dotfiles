local get_icon = require("astronvim.utils").get_icon
local status = require "astronvim.utils.status"

return {
  "rebelot/heirline.nvim",
  dependencies = { "Mofiqul/dracula.nvim" },
  opts = function(_, opts)
    opts.statusline = {
      {
        hl = { bg = "folder_icon_bg", fg = "file_info_bg" },
        status.component.builder {
          { provider = "" },
          hl = { bg = "folder_icon_bg", fg = "bg" },
          surround = { separator = "none" },
          padding = { left = 1, right = 1 },
        },
        status.component.builder {
          { provider = get_icon "FolderClosed" },
          hl = { bg = "folder_icon_bg", fg = "bg" },
          surround = { separator = "none" },
          padding = { left = 1, right = 1 },
        },
        status.component.file_info {
          filename = {
            fname = function(nr) return vim.fn.getcwd(nr) end,
            surround = { separator = "none" },
          },
          padding = { right = 1, left = 1 },
          file_modified = false,
          file_read_only = false,
          file_icon = false,
          hl = { fg = "bg", bg = "folder_icon_bg" },
          surround = {
            separator = "right",
            color = function() return { right = status.hl.mode_bg(), main = "folder_icon_bg" } end,
          },
        },
      },
      status.component.mode {
        mode_text = { icon = { kind = "VimIcon", padding = { right = 1, left = 1 } } },
        padding = { right = 1 },
        hl = function() return { bg = status.hl.mode_bg(), fg = "bg", bold = true } end,
        surround = {
          separator = "right",
          color = function() return { main = status.hl.mode_bg(), right = "bg" } end,
        },
      },
      status.component.lsp {
        lsp_progress = false,
        surround = { separator = "none" },
        hl = { fg = "buffer_overflow_fg", bg = "bg" },
        padding = { right = 1 },
        lsp_client_names = {
          truncate = 0.10,
          icon = {
            padding = { right = 1, left = 1 },
          },
        },
      },
      status.component.fill(),
      status.component.lsp { lsp_client_names = false, surround = { separator = "none" } },
      status.component.fill(),
      status.component.diagnostics {
        surround = { separator = "none" },
        padding = { right = 1, left = 1 },
      },
      -- filename
      status.component.file_info {
        padding = { right = 1 },
        file_icon = false,
        file_modified = false,
        filename = { padding = { left = 1 } },
        hl = { bg = "file_info_bg", fg = "white" },
        surround = { separator = "left", color = { main = "file_info_bg", left = "bg" } },
      },
      -- filetype
      status.component.file_info {
        filetype = {},
        filename = false,
        file_icon = { padding = { left = 1 } },
        file_modified = false,
        padding = { right = 1 },
        surround = { separator = "left", color = { main = "command", left = "file_info_bg" } },
        hl = { bg = "command", fg = "bg", bold = true },
      },
      status.component.git_diff {
        surround = { separator = "left", color = { main = "bg", left = "command" } },
        hl = { bg = "bg" },
        padding = { right = 1 },
      },
      status.component.git_branch {
        hl = { bg = "git_branch_fg", fg = "bg" },
        git_branch = { icon = { kind = "GitBranch" }, padding = { left = 1, right = 1 } },
        surround = {
          separator = "left",
          color = { main = "git_branch_fg", left = "bg" },
        },
      },
      status.component.nav {
        percentage = false,
        scrollbar = false,
        hl = { bg = "bg", fg = "fg" },
        ruler = { padding = { left = 1 } },
        surround = { separator = "left", color = { main = "bg", left = "git_branch_fg" } },
      },
    }

    opts.winbar = {
      -- create custom winbar
      -- store the current buffer number
      init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
      fallthrough = false, -- pick the correct winbar based on condition
      -- inactive winbar
      {
        condition = function() return not status.condition.is_active() end,
        -- show the path to the file relative to the working directory
        status.component.separated_path { path_func = status.provider.filename { modify = ":.:h" } },
        -- add the file name and icon
        status.component.file_info {
          file_icon = { hl = status.hl.file_icon "winbar", padding = { left = 0 } },
          file_modified = false,
          file_read_only = false,
          hl = status.hl.get_attributes("winbarnc", true),
          surround = false,
          update = "BufEnter",
        },
      },
      -- active winbar
      {
        -- show the path to the file relative to the working directory
        status.component.separated_path { path_func = status.provider.filename { modify = ":.:h" } },
        -- add the file name and icon
        status.component.file_info { -- add file_info to breadcrumbs
          file_icon = { hl = status.hl.filetype_color, padding = { left = 0 } },
          file_modified = false,
          file_read_only = false,
          hl = status.hl.get_attributes("winbar", true),
          surround = false,
          update = "BufEnter",
        },
        -- show the breadcrumbs
        status.component.breadcrumbs {
          icon = { hl = true },
          hl = status.hl.get_attributes("winbar", true),
          prefix = true,
          padding = { left = 0 },
        },
      },
    }
    -- return the final options table
    return opts
  end,
}
