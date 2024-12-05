-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here
-- Show an error message if a disabled key is pressed
local msg = [[<cmd>echohl Error | echo "KEY DISABLED" | echohl None<CR>]]

-- Disable arrow keys in insert mode with a styled message
vim.api.nvim_set_keymap("i", "<Up>", "<C-o>" .. msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap("i", "<Down>", "<C-o>" .. msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap("i", "<Left>", "<C-o>" .. msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap("i", "<Right>", "<C-o>" .. msg, { noremap = true, silent = false })

-- Disable arrow keys in normal mode with a styled message
vim.api.nvim_set_keymap("n", "<Up>", msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap("n", "<Down>", msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap("n", "<Left>", msg, { noremap = true, silent = false })
vim.api.nvim_set_keymap("n", "<Right>", msg, { noremap = true, silent = false })
