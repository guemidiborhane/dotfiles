local plugins = {
    {
        'Exafunction/codeium.vim',
        lazy = false,
    },

    {
        'neovim/nvim-lspconfig',
        config = function ()
          require 'plugins.configs.lspconfig'
          require 'custom.configs.lspconfig'
        end
    },

    {
        "williamboman/mason.nvim",
        opts = {
          ensure_installed = {
            'solargraph'
          }
        }
    },

    {
        "NvChad/nvterm",
        init = function()
          require("core.utils").load_mappings "nvterm"
        end,
        config = function(_, opts)
          require "base46.term"
          require("nvterm").setup(opts)
          require 'custom.configs.nvterm'
        end,
    },

    {
        "ahmedkhalf/project.nvim",
        lazy = false,
        config = function()
            require("project_nvim").setup()
            require 'custom.configs.tree'
            require 'custom.configs.telescope'
        end
    }
}

return plugins
