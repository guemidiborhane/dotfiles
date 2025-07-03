return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader><space>",
      function()
        local git_dir = os.getenv("GIT_DIR")
        local in_yadm = git_dir and git_dir:match("yadm/repo%.git$") ~= nil
        local show_untracked = not in_yadm

        local ok = pcall(require("telescope.builtin").git_files, { show_untracked = show_untracked })
        if not ok then
          require("telescope.builtin").find_files()
        end
      end,
      desc = "Find Files (git-files if in Git repo)",
    },
  },
}
