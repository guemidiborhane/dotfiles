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

local find_files_command = "<cmd> Telescope find_files <CR>"

local find_files = {
    find_files_command,
    "find files",
}

-- close splits and last window if no splits
local close_tab = {
    function()
        require("nvchad_ui.tabufline").close_buffer()
    end,
    "close current tab",
}

local vertical_split = {
    "<cmd> vsplit <CR>" .. find_files_command,
    "vertical split",
}

local horizontal_split = {
    "<cmd> split <CR>" .. find_files_command,
    "horizontal split",
}

M.personal = {
    n = {
        ["<C-p>"] = find_files,
        ["<C-k>w"] = { "<cmd> bufdo bd<CR> <cmd> Nvdash<CR>", "close all buffers" },
        ["<C-`>"] = toggle_nvterm,
        ["<S-A-p>"] = { "<cmd> Telescope projects <CR>" },
        ["<C-w>"] = close_tab,
        ["<C-l>"] = vertical_split,
        ["<C-j>"] = horizontal_split,
    },
    i = {
        ["<C-p>"] = find_files,
        ["<C-s>"] = { "<cmd> write <CR>", "save" },
        ["<C-w>"] = close_tab,
        ["<C-l>"] = vertical_split,
        ["<C-j>"] = horizontal_split,
    },
    t = {
        ["<C-`>"] = toggle_nvterm,
    },
}

return M
