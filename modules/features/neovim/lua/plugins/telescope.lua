return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader><space>",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find Files (git-files if in Git repo)",
    },
  },
}
