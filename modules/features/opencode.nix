{ self, ... }: {
  flake.modules.homeManager.opencode =
    { user, ... }:
    {
      imports = [ self.modules.homeManager.omniroute ];
      dex.persist.directories = [
        ".config/opencode"
        ".local/share/opencode"
        ".local/state/opencode"
      ];
      programs.opencode = {
        enable = user.features.ai.opencode or false;
        cli = {
          keybinds.leader = "alt+b";
          theme.name = "dracula";
        };
      };
    };
}
