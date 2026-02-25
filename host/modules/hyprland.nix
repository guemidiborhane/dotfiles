{ inputs, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
    portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
