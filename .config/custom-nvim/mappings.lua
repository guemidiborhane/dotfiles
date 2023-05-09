local M = {}

M.disabled = {
    n = {
        ["C-p"] = "",
    },
}

local toggle_nvterm = {
    function()
        require("nvterm.terminal").toggle("float")
    end,
    "toggle floating term",
}

M.personal = {
    n = {
        ["<C-p>"] = { "<cmd> Telescope find_files <CR>", "find files" },
        ["<C-S-p>"] = { "<cmd> Telescope commands <CR>", "show commands" },
        ["<C-k>w"] = { "<cmd> :bufdo bd<CR> :Nvdash<CR>", "close all buffers" },
        ["<C-`>"] = toggle_nvterm,
        ["<S-A-p>"] = { "<cmd> Telescope projects <CR>" },
        ["<C-w>"] = { "<cmd> bufdo bd<CR>", "close current buffer" },
    },
    i = {
        ["<C-s>"] = { "<cmd> write <CR>", "save" },
    },
    t = {
        ["<C-`>"] = toggle_nvterm,
    },
}

return M
