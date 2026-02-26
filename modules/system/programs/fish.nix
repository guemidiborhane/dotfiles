{ _, ... }:
{
  flake.nixosModules.programs-fish =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        package = pkgs.unstable.fish;
      };
    };
}
