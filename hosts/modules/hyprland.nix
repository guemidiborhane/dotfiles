{ inputs, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    # set the flake package
    package = pkgs.unstable.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
