{ _, ... }:
{
  flake.modules.homeManager.programs-fish =
    { pkgs, lib, ... }:
    {
      programs.fish = {
        enable = true;
        package = pkgs.unstable.fish;
      };

      xdg.configFile."fish/config.fish".enable = lib.mkForce false;
    };
}
