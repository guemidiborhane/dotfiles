-- Remove trailing whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function(_)
    local save_cursor = vim.fn.getpos "."
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos(".", save_cursor)
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  command = "TypescriptRemoveUnused",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Fix all eslint errors",
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
  callback = function()
    if vim.fn.exists ":EslintFixAll" > 0 then vim.cmd "EslintFixAll" end
  end,
})
