local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

require("mason").setup()

require("mason-null-ls").setup({
    ensure_installed = {
        "rubocop",
        "stylua",
        "jq",
        "prettierd",
        "htmlbeautifier",
        "rustywind",
    },
    automatic_installation = true,
    handlers = {},
})

require("null-ls").setup({
    sources = {},
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,
})
