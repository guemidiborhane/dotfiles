local M =  {}

M.disabled = {
  n = {
    ["C-p"] = ""
  }
}

M.personal = {
  n = {
    ["<C-p>"] = { "<cmd> Telescope find_files <CR>", "find files" },
    ["<C-k>w"] = { "<cmd> :bufdo bd<CR> :Nvdash<CR>", "close all buffers" }
  }
}


return M
