{
  config,
  pkgs,
  lib,
  inputs,
  meta,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  home = {
    stateVersion = "25.11";

    enableNixpkgsReleaseCheck = true;
    homeDirectory = "/home/${meta.alias}";
    username = "${meta.alias}";
  };
  programs.home-manager.enable = true;

  imports = [
    ./zen-browser.nix
  ];

  home.packages = with pkgs; [
     tmux
     zoxide
     fzf
     ghostty
     waybar
     bitwarden-desktop
     starship
     atuin
     bat
     wlogout
     dracula-theme
     kora-icon-theme
     banana-cursor
     hyprpaper
     hypridle
     hyprlock
     mise
     swaynotificationcenter
     wiremix
     pulseaudio
     brightnessctl
     networkmanagerapplet
  ];

  services.hyprpaper.enable = true;

  xdg.enable = true;
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
}
