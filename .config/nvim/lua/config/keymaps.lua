-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = require("utils").set_keymap

map("i", "jj", "<Esc>")

-- Buffers
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", "Next open Buffer on tabline")
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", "Previous open Buffer on tabline")
map("n", "<leader>bf", "<cmd>Telescope buffers<CR>", "Find Buffer")

local show_dashboard = function()
  vim.cmd("enew")
  Snacks.dashboard()
end
-- stylua: ignore start
map("n", "<leader>h", show_dashboard, "Show dashboard")
-- stylua: ignore end
