-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)

local find_files_command = "<cmd> Telescope find_files <CR>"

local find_files = {
  find_files_command,
  desc = "find files",
}

local vertical_split = {
  "<cmd> vsplit <CR>" .. find_files_command,
  desc = "vertical split",
}

local horizontal_split = {
  "<cmd> split <CR>" .. find_files_command,
  desc = "horizontal split",
}

local close_buffer = {
  function()
    local bufs = vim.fn.getbufinfo { buflisted = true }
    require("astronvim.utils.buffer").close(0)
    if require("astronvim.utils").is_available "alpha-nvim" and not bufs[2] then require("alpha").start(true) end
  end,
  desc = "Close buffer",
}

local close_all_buffers = {
  function()
    local bufs = vim.fn.getbufinfo { buflisted = true }
    for _, buf in ipairs(bufs) do
      require("astronvim.utils.buffer").close(buf.bufnr)
    end
    if require("astronvim.utils").is_available "alpha-nvim" and not bufs[2] then require("alpha").start(true) end
  end,
  desc = "Close all buffers",
}

local toggle_neotree = {
  "<cmd> Neotree toggle <CR>",
  desc = "toggle neotree",
}

local toggle_term = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }

local next_buffer = {
  function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
  desc = "Next buffer",
}
local previous_buffer = {
  function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
  desc = "Previous buffer",
}

-- nnoremap <A-j> :m .+1<CR>==
-- nnoremap <A-k> :m .-2<CR>==
-- inoremap <A-j> <Esc>:m .+1<CR>==gi
-- inoremap <A-k> <Esc>:m .-2<CR>==gi
-- vnoremap <A-j> :m '>+1<CR>gv=gv
-- vnoremap <A-k> :m '<-2<CR>gv=gv

return {
  n = {
    ["<C-p>"] = find_files,
    ["<C-k>w"] = close_all_buffers,
    ["<S-A-p>"] = { "<cmd> Telescope projects <CR>", desc = "List projects" },
    ["|"] = vertical_split,
    ["\\"] = horizontal_split,
    ["<C-n>"] = toggle_neotree,
    ["<C-w>"] = close_buffer,
    ["<C-`>"] = toggle_term,
    ["<C-Tab>"] = next_buffer,
    ["<C-S-Tab>"] = previous_buffer,
    ["<A-k>"] = {
      ":m .-2<CR>==",
      desc = "Move current line up",
    },
    ["<A-j>"] = {
      ":m .+1<CR>==",
      desc = "Move current line down",
    },
  },
  i = {
    ["<C-p>"] = find_files,
    ["<C-s>"] = { "<cmd> write <CR>", desc = "save" },
    ["<C-n>"] = toggle_neotree,
    ["<C-w>"] = close_buffer,
    ["<C-`>"] = toggle_term,
    ["<C-Tab>"] = next_buffer,
    ["<C-S-Tab>"] = previous_buffer,
    ["<A-k>"] = {
      "<Esc>:m .-2<CR>==gi",
      desc = "Move current line up",
    },
    ["<A-j>"] = {
      "<Esc>:m .+1<CR>==gi",
      desc = "Move current line down",
    },
  },
  v = {
    ["<A-k>"] = {
      ":m '<-2<CR>gv=gv",
      desc = "Move selected lines down",
    },
    ["<A-j>"] = {
      ":m '>+1<CR>gv=gv",
      desc = "Move selected lines up",
    },
  },
  t = {
    ["<C-`>"] = toggle_term,
  },
}
