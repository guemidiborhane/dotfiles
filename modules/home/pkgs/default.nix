{ self, ... }:
{
  flake.modules.homeManager.pkgs =
    { _, ... }:
    {
      imports = with self.modules.homeManager; [
        pkgs-shell
        pkgs-wireless
      ];
    };
}
