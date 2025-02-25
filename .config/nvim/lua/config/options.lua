-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local o = vim.opt
-- disable animations
vim.g.snacks_animate = false

-- disable swapfiles
o.swapfile = false

-- sync buffers between neovim windows
o.autoread = true

-- faster completion
o.updatetime = 250
