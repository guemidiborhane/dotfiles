{ _, ... }:
{
  flake.modules.nixos.thunar =
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
