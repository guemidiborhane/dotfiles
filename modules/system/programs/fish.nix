{ _, ... }:
{
  flake.modules.nixos.programs-fish =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        package = pkgs.unstable.fish;
      };
    };
}
