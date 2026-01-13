{ pkgs, ... }:
{
  enable = true;
  plugins = with pkgs.unstable; [
    thunar-volman
    thunar-archive-plugin
  ];
}
