# Discovers a dotfiles tree laid out like $HOME (stow convention: `dot_foo` →
# `.foo`) and returns a flat attrs ready for `dex.dotfiles`. Directories listed
# in `dirUnits` are linked as a whole directory instead of being recursed into;
# paths there use the resolved name (after dot_ stripping).
{ lib, ... }:
{
  flake.helpers = {
    dotfiles.discover =
      dir: dirUnits:
      let
        resolveName = name: if lib.hasPrefix "dot_" name then ".${lib.removePrefix "dot_" name}" else name;

        collect =
          dir: prefix:
          lib.concatMapAttrs (
            name: type:
            let
              resolved = resolveName name;
              relPath = if prefix == "" then resolved else "${prefix}/${resolved}";
              absPath = dir + "/${name}";
            in
            if type != "directory" then
              { ${relPath} = absPath; }
            else if lib.elem relPath dirUnits then
              { ${relPath} = absPath; }
            else
              collect absPath relPath
          ) (builtins.readDir dir);
      in
      lib.filterAttrs (k: _: !(lib.hasSuffix ".nix" k)) (collect dir "");
  };
}
