require('nvterm').setup({
  terminals = {
    shell = vim.o.shell,
    type_opts = {
      float = {
        relative = 'editor',
        row = 0.2,
        col = 0,
        width = 1,
        height = 0.6,
        border = "single"
      },
    }
  },
  behavior = {
    autoclose_on_quit = {
      enabled = true,
      confirm = true,
    },
    close_on_exit = true,
    auto_insert = true,
  },
})
