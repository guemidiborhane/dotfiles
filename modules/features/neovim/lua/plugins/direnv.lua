return {
  "NotAShelf/direnv.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    autoload_direnv = true,
  }
}
