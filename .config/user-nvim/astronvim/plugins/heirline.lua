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
          { provider = get_icon "FolderClosed" },
          hl = { bg = "folder_icon_bg", fg = "bg" },
          surround = { separator = "tab", color = { main = "folder_icon_bg", right = "folder_icon_bg" } },
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
            separator = "left",
            color = function() return { right = status.hl.mode_bg(), main = "folder_icon_bg" } end,
          },
        },
      },
      status.component.mode {
        mode_text = { icon = { kind = "VimIcon", padding = { right = 1, left = 0 } } },
        padding = { right = 1 },
        surround = {
          separator = "left",
          color = function() return { main = status.hl.mode_bg(), right = "bg" } end,
        },
      },

      status.component.lsp {
        lsp_progress = false,
        surround = { separator = "none" },
        hl = { fg = "buffer_overflow_fg" },
        lsp_client_names = {
          icon = {
            padding = { right = 1, left = 0 },
          },
        },
      },
      status.component.fill(),
      status.component.lsp { lsp_client_names = false, surround = { separator = "none" } },
      status.component.diagnostics(),
      status.component.nav {
        ruler = { padding = { left = 1, right = 1 } },
        percentage = false,
        scrollbar = false,
        surround = { separator = "none" },
      },
      status.component.treesitter { padding = { right = 1, left = 1 } },
      status.component.file_info {
        filetype = {},
        filename = false,
        file_icon = { padding = { left = 1 } },
        file_modified = false,
        padding = { right = 1 },
        surround = { separator = "tab", color = { main = "command", left = "bg" } },
        hl = { bg = "command", fg = "bg", bold = true },
      },
      status.component.git_diff {
        surround = { separator = "none" },
        hl = { bg = "bg" },
        padding = { right = 1 },
      },
      status.component.git_branch {
        hl = { bg = "git_branch_fg", fg = "bg" },
        git_branch = { icon = { kind = "GitBranch" }, padding = { left = 1, right = 1 } },
        surround = {
          separator = "top_left",
          color = "git_branch_fg",
        },
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
