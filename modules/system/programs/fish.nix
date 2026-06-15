{ _, ... }:
{
  flake.modules.nixos.fish =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        package = pkgs.unstable.fish;
      };
    };
}
