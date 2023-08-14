return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "left",
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          always_show = {
            "user",
          },
        },
      },
    },
  },
}
