{ _, ... }:
{
  flake.modules.nixos.programs-thunar =
    { pkgs, ... }:
    {
      programs.thunar = {
        enable = true;
        plugins = with pkgs.unstable; [
          thunar-volman
          thunar-archive-plugin
        ];
      };
    };
}
