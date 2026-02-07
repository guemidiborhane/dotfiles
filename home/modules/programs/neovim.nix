{ pkgs, h, inputs, ... }:
let
  enabled_languages = [
    "nix"
    "just"
    "toml"
    "yaml"
    "bash"
    "go"
    "html"
    "css"
    "ts"
    "ruby"
    "tailwind"
  ];
in {
  enable = true;
  settings = {
    vim = {
      viAlias = true;
      vimAlias = true;

      globals.mapleader = " ";
      lineNumberMode = "relNumber";
      undoFile.enable = true;
      searchCase = "smart";

      options = {
        cursorline = true;
        confirm = true;
        splitbelow = true;
        splitright = true;
        wrap = false;
      };

      visuals = {
        nvim-cursorline.enable = true;
        indent-blankline.enable = true;
        nvim-web-devicons.enable = true;
        tiny-devicons-auto-colors.enable = true;
      };

      keymaps = import ./neovim.d/keymaps.nix;

      statusline.lualine = import ./neovim.d/lualine.nix;

      extraPlugins.tpipeline.package = pkgs.vimPlugins.vim-tpipeline;
      globals.tpipeline_clearstl = 1;
      globals.tpipeline_preservebg = 1;
      globals.tpipeline_restore = 0;
      globals.tpipeline_autoembed = 0;

      lazy.plugins = {
        "dracula.nvim" = {
          package = pkgs.vimPlugins.dracula-nvim;
          after = /* lua */''
            local dracula = require("dracula");
            local colors = dracula.colors();

            dracula.setup({
                lualine_bg_color = colors.bg,
                overrides = {
                  StatusLine = { bg = colors.bg, fg = colors.fg }
                }
            })
            dracula.load()
          '';
        };
        "persistence.nvim" = {
          package = pkgs.vimPlugins.persistence-nvim;
          setupModule = "persistence";
        };
        "hardtime.nvim" = {
          package = pkgs.vimPlugins.hardtime-nvim;
          setupModule = "hardtime";
        };
      };
      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      binds.whichKey.enable = true;
      telescope = h.enabled;
      autocomplete.nvim-cmp = h.enabled;
      filetree.neo-tree = {
        enable = true;
        setupOpts.window.position = "right";
      };
      utility.smart-splits = {
        enable = true;
        keymaps = {
          swap_buf_left = null;
          swap_buf_down = null;
          swap_buf_up = null;
          swap_buf_right = null;
        };
      };
      comments.comment-nvim.enable = true;
      mini.tabline.enable = true;

      ui = {
        noice = import ./neovim.d/noice.nix;
        colorizer.enable = true;
      };

      utility.snacks-nvim = import ./neovim.d/snacks.nix;

      git = {
        enable = true;
        gitsigns.enable = true;
      };

      treesitter = {
        enable = true;
        context.enable = true;
        fold = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          hyprlang
        ];
      };

      lsp = {
        enable = true;
        null-ls.enable = true;
        lspconfig.enable = true;
      };

      languages = {
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        enableFormat = true;
      } // builtins.listToAttrs(map(name: {
        inherit name;
        value = { enable = true; };
      }) enabled_languages);

    };
  };
}
