{ self, ... }: {
  flake.modules.homeManager.opencode =
    { user, ... }:
    {
      imports = [ self.modules.homeManager.omniroute ];
      dex.persist.directories = [
        ".local/share/opencode"
        ".local/state/opencode"
      ];
      programs.opencode = {
        enable = user.features.ai.opencode or false;
        tui = {
          keybinds.leader = "alt+b";
          theme = "dracula";
        };
      };
    };
}
