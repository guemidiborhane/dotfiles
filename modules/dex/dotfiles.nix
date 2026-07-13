{ _, ... }:
{
  flake.modules.homeManager.dex-dotfiles =
    ctx@{ config, lib, ... }:
    let
      # A single dotfile value: a path, false, or a group (attrs of path|false)
      dotfileValue = lib.types.oneOf [
        lib.types.path
        (lib.types.enum [ false ])
        (lib.types.attrsOf (lib.types.either lib.types.path (lib.types.enum [ false ])))
      ];
    in
    {
      options.dex.dotfiles = lib.mkOption {
        type = lib.types.attrsOf dotfileValue;
        default = { };
        description = ''
          Declarative home directory symlinks. Keys are paths relative to $HOME.
          Values can be:
            - A path        → symlinks $HOME/<key> → flake-relative source
            - false         → disables the entry (enable = false)
            - An attrset    → grouped: each inner key becomes $HOME/<key>/<inner-key>
                              Inner values follow the same path | false rule.
        '';
        example = lib.literalExpression ''
          {
            ".scripts"              = ./.;
            ".config/hypr"         = {
              "hyprland.lua"       = ./hyprland.lua;
              "hyprpaper.conf"     = ./hyprpaper.conf;
              "hypr-unused.conf"   = false;
            };
            ".config/nvim"         = ./nvim;
            ".config/unused-tool" = false;
          }
        '';
      };

      config =
        let
          setupSymlinkRel =
            relativePath:
            let
              baseStr = toString relativePath;
              parts = lib.splitString "-source/" baseStr;
              relPart = if builtins.length parts > 1 then builtins.elemAt parts 1 else "";
            in
            config.lib.file.mkOutOfStoreSymlink "${ctx.metadata.flake}/${relPart}";

          # Expand one top-level entry into a flat attrs of home.file entries.
          # Returns: attrsOf { source } | attrsOf { enable = false }
          expandEntry =
            key: value:
            let
              absKey = "${config.home.homeDirectory}/${key}";
            in
            if value == false then
              {
                ${absKey} = {
                  enable = false;
                };
              }
            else if builtins.isAttrs value then
              lib.mapAttrs' (
                innerKey: innerValue:
                lib.nameValuePair "${absKey}/${innerKey}" (
                  if innerValue == false then { enable = false; } else { source = setupSymlinkRel innerValue; }
                )
              ) value
            else
              {
                ${absKey} = {
                  source = setupSymlinkRel value;
                };
              };
        in
        {
          home.file = lib.foldlAttrs (
            acc: key: value:
            acc // expandEntry key value
          ) { } config.dex.dotfiles;
        };
    };
}
