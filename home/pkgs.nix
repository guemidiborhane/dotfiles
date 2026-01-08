{
  pkgs,
  ...
}: with pkgs; [
  pkgs.nur.repos.nltch.spotify-adblock
  tmux
  waybar
  bitwarden-desktop
  wlogout
  dracula-theme
  kora-icon-theme
  banana-cursor
  hyprlock
  wiremix
  pulseaudio
  brightnessctl
  networkmanagerapplet
  glib # gsettings
]
