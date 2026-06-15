{ _, ... }:
{
  flake.modules.homeManager.yazi =
    { pkgs, lib, ... }:
    {
      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
        settings = {
          mgr = {
            show_hidden = false;
            sort_by = "mtime";
            sort_dir_first = true;
            sort_reverse = true;
          };
          plugin.prepend_fetchers = [
            {
              url = "*";
              run = "git";
              group = "git";
            }
            {
              url = "*/";
              run = "git";
              group = "git";
            }
          ];
        };

        theme =
          let
            sep = "█";
            separators = {
              open = sep;
              close = sep;
            };
          in
          {
            flavor.dark = "dracula";
            indicator.padding = separators;
            status = {
              sep_left = separators;
              sep_right = separators;
            };
          };
      };

      dex.dotfiles.".config/yazi" = {
        "init.lua" = ./init.lua;
        "package.toml" = ./package.toml;
        "keymap.toml" = ./keymap.toml;
      };
      home.activation.yazi-packages-install = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        ${pkgs.yazi}/bin/ya pa install 2>/dev/null || true
      '';
    };
}
