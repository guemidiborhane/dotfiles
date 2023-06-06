return {
  -- Set colorscheme to use
  colorscheme = "dracula",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  -- modify variables used by heirline but not defined in the setup call directly
  heirline = {
    attributes = {
      mode = { bold = true },
    },
    icon_highlights = {
      file_icon = {
        statusline = false,
      },
    },
  },
}
