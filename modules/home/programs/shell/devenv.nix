{ _, ... }:
{
  flake.modules.homeManager.devenv =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.devenv ];
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
