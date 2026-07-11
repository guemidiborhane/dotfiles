# This module is purely a source of truth for what
# lives under $HOME.
#
# Layout mirrors $HOME exactly:
#   - Directories/files named dot_foo  → .foo  (Stow convention)
#   - Everything else keeps its name as-is
#   - .nix files are excluded automatically
#   - Paths listed in `dirUnits` are linked as a whole directory
#     rather than being recursed into file-by-file
{ self, ... }:
{
  flake.modules.homeManager.dotfiles =
    { lib, config, ... }:
    with lib;
    let
      dotfilesDir = ./.;
      wallpapersPath = "Pictures/wallpaper";
      scriptsPath = ".local/bin";

      # Directories that should be symlinked as a unit instead of
      # being expanded into individual file links.
      # Paths are relative to dotfilesDir, using the *resolved* name
      # (i.e. after dot_ stripping), e.g. ".config/easyeffects/irs".
      dirUnits = [
        ".config/containers/systemd"
        ".config/easyeffects/irs"
        ".config/easyeffects/output"
        ".config/qt5ct"
        ".config/legcord/themes"
        scriptsPath
        wallpapersPath
      ];

      # Strip the dot_ prefix and replace with "." if present.
      resolveName = name: if hasPrefix "dot_" name then ".${removePrefix "dot_" name}" else name;

      collect =
        dir: prefix:
        concatMapAttrs (
          name: type:
          let
            resolved = resolveName name;
            relPath = if prefix == "" then resolved else "${prefix}/${resolved}";
            absPath = dir + "/${name}";
          in
          if type != "directory" then
            { ${relPath} = absPath; }
          else if elem relPath dirUnits then
            { ${relPath} = absPath; }
          else
            collect absPath relPath
        ) (builtins.readDir dir);

      discovered = filterAttrs (k: _: !(hasSuffix ".nix" k)) (collect dotfilesDir "");
    in
    {
      imports = [ self.modules.homeManager.dex-dotfiles ];
      config = {
        dex.dotfiles = discovered;

        home.sessionVariables.PATH = "$PATH:${config.home.homeDirectory}/${scriptsPath}";
        programs.noctalia-shell.settings.wallpaper.directory =
          "${config.home.homeDirectory}/${wallpapersPath}";
      };
    };
}
