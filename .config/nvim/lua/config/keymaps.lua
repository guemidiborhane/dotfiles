-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = require("utils").set_keymap

map("i", "jj", "<Esc>")

-- Buffers
map("n", "<Tab>", ":bnext<CR>", "Next open Buffer on tabline")
map("n", "<S-Tab>", ":bprevious<CR>", "Previous open Buffer on tabline")
map("n", "<leader>bf", ":Telescope buffers<CR>", "Find Buffer")
