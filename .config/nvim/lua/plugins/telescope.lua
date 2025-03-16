return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader><space>",
      function()
        local ok = pcall(require("telescope.builtin").git_files)
        if not ok then
          require("telescope.builtin").find_files()
        end
      end,
      desc = "Find Files (git-files if in Git repo)",
    },
  },
}
