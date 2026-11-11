_: {
  flake.modules.homeManager.host-dotfiles =
    { host, h, ... }:
    let
      hostDotfiles = ./${host.name}/dotfiles;
      dirUnits = [
        ".local/share/easyeffects/irs"
        ".local/share/easyeffects/output"
      ];
    in
    {
      dex.dotfiles = if builtins.pathExists hostDotfiles then (h.dotfiles.discover hostDotfiles dirUnits) else { };
      services.easyeffects = {
        # only enable on hosts with profiles.
        enable = builtins.pathExists "${hostDotfiles}/dot_local/share/easyeffects";
      };
    };
}
