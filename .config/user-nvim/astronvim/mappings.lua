-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)

local find_files_command = "<cmd> Telescope find_files <CR>"
local utils = require "astronvim.utils"

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

local toggle_neotree = {
  "<cmd> Neotree toggle <CR>",
  desc = "toggle neotree",
}

local toggle_term = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }

local next_buffer = {
  function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
  desc = "Next buffer",
}
local previous_buffer = {
  function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
  desc = "Previous buffer",
}

return {
  n = {
    ["<C-p>"] = find_files,
    ["<S-A-p>"] = { "<cmd> Telescope projects <CR>", desc = "List projects" },
    ["|"] = vertical_split,
    ["\\"] = horizontal_split,
    ["<C-n>"] = toggle_neotree,
    ["`"] = toggle_term,
    ["<C-PageDown>"] = next_buffer,
    ["<C-PageUp>"] = previous_buffer,
    ["<A-k>"] = {
      ":m .-2<CR>==",
      desc = "Move current line up",
    },
    ["<A-j>"] = {
      ":m .+1<CR>==",
      desc = "Move current line down",
    },
    ["<Tab>"] = {
      function()
        if #vim.t.bufs > 1 then
          require("telescope.builtin").buffers { sort_mru = true, ignore_current_buffer = true }
        else
          require("astronvim.utils").notify "No other buffers open"
        end
      end,
      desc = "Switch Buffers",
    },
    ["<leader>m"] = { "<cmd>Mason<CR>", desc = "Mason" },
    ["<C-Tab>"] = { "<C-^>" },
    ["<leader>tc"] = { function() utils.toggle_term_cmd "make console" end, desc = "ToggleTerm make console" },
  },
  i = {
    ["<C-p>"] = find_files,
    -- write file and escape to normal model
    ["<C-s>"] = { "<Esc><cmd> write <CR>", desc = "Save buffer and return to Normal mode" },
    ["<C-n>"] = toggle_neotree,
    ["<C-PageDown>"] = next_buffer,
    ["<C-PageUp>"] = previous_buffer,
    ["<A-k>"] = {
      "<Esc>:m .-2<CR>==gi",
      desc = "Move current line up",
    },
    ["<A-j>"] = {
      "<Esc>:m .+1<CR>==gi",
      desc = "Move current line down",
    },
  },
  v = {
    ["<A-k>"] = {
      ":m '<-2<CR>gv=gv",
      desc = "Move selected lines down",
    },
    ["<A-j>"] = {
      ":m '>+1<CR>gv=gv",
      desc = "Move selected lines up",
    },
  },
  t = {
    ["`"] = toggle_term,
  },
}
