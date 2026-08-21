{ _, ... }:
{
  flake.modules.homeManager.opencode =
    { lib, user, ... }:
    lib.mkIf (user.features.ai.opencode or false) {
      dex.persist.directories = [
        ".local/share/opencode"
        ".local/state/opencode"
      ];

      programs.opencode = {
        enable = true;
        tui = {
          keybinds.leader = "alt+b";
          theme = "dracula";
        };
      };
    };
}
