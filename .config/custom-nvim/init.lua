local opt = vim.opt

-- Indenting
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4

if vim.g.neovide then
    vim.o.guifont = "Operator Mono Book:h14"
    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0
    vim.g.neovide_confirm_quit = true
    vim.g.neovide_cursor_animation_length = 0.05
end

