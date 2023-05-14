-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)

local find_files_command = "<cmd> Telescope find_files <CR>"

local find_files = {
  find_files_command,
  desc = "find files",
}

local vertical_split = {
  "<cmd> vsplit <CR>" .. find_files_command,
  desc = "vertical split",
}

local horizontal_split = {
  "<cmd> split <CR>" .. find_files_command,
  desc = "horizontal split",
}

local close_buffer = {
  function()
    local bufs = vim.fn.getbufinfo { buflisted = true }
    require("astronvim.utils.buffer").close(0)
    if require("astronvim.utils").is_available "alpha-nvim" and not bufs[2] then require("alpha").start(true) end
  end,
  desc = "Close buffer",
}

local toggle_neotree = {
  "<cmd> Neotree toggle <CR>",
  desc = "toggle neotree",
}

local toggle_term = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }

return {
  n = {
    ["<C-p>"] = find_files,
    ["<C-k>w"] = { "<cmd> bufdo bd<CR> <cmd> Nvdash<CR>", desc = "close all buffers" },
    ["<S-A-p>"] = { "<cmd> Telescope projects <CR>", desc = "List projects" },
    ["<C-l>"] = vertical_split,
    ["<C-j>"] = horizontal_split,
    ["<C-n>"] = toggle_neotree,
    ["<C-w>"] = close_buffer,
    ["<C-`>"] = toggle_term,
  },
  i = {
    ["<C-p>"] = find_files,
    ["<C-s>"] = { "<cmd> write <CR>", desc = "save" },
    ["<C-l>"] = vertical_split,
    ["<C-j>"] = horizontal_split,
    ["<C-n>"] = toggle_neotree,
    ["<C-w>"] = close_buffer,
    ["<C-`>"] = toggle_term,
  },
  t = {
    ["<C-`>"] = toggle_term,
  },
}
