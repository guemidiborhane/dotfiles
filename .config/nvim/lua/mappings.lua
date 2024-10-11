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

local toggle_neotree = {
  "<cmd> Neotree toggle <CR>",
  desc = "toggle neotree",
}

local next_buffer = {
  function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
  desc = "Next buffer",
}
local previous_buffer = {
  function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
  desc = "Previous buffer",
}

return {
  n = {
    ["<C-p>"] = find_files,
    ["\\"] = toggle_neotree,
    ["<A-PageDown>"] = next_buffer,
    ["<A-PageUp>"] = previous_buffer,
    ["<Tab>"] = { "<C-^>" },
    ["<C-R>"] = {
      function()
        if #vim.t.bufs > 1 then
          require("telescope.builtin").buffers { sort_mru = true, ignore_current_buffer = true }
        else
          require("astrocore").notify "No other buffers open"
        end
      end,
      desc = "Switch Buffers",
    },
    ["<Leader>m"] = { "<cmd>Mason<CR>", desc = "Mason" },
    ["<Leader>tc"] = {
      "<cmd>!tmux split-window -h make console<CR>",
      desc = "open console in spit",
    },
    ["<Leader>tf"] = {
      "<cmd>!tmux split-window -h make fish<CR>",
      desc = "open console in spit",
    },
    ["<Leader>tC"] = {
      "<cmd>!tmux split-window make console<CR>",
      desc = "open console in spit",
    },
    ["<Leader>tF"] = {
      "<cmd>!tmux split-window make fish<CR>",
      desc = "open console in spit",
    },
    ["<Leader>c"] = {
      function()
        local bufs = vim.fn.getbufinfo { buflisted = true }
        require("astrocore.buffer").close(0)
        if require("astrocore").is_available "alpha-nvim" and not bufs[2] then require("alpha").start(true) end
      end,
      desc = "Close buffer",
    },
  },
  i = {
    ["<C-p>"] = find_files,
    -- write file and escape to normal model
    ["<C-s>"] = { "<Esc><cmd> write <CR>", desc = "Save buffer and return to Normal mode" },
    ["<A-PageDown>"] = next_buffer,
    ["<A-PageUp>"] = previous_buffer,
  },
  v = {},
  t = {},
}
