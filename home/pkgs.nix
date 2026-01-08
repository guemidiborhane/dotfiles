{
  pkgs,
  ...
}: with pkgs; [
  pkgs.nur.repos.nltch.spotify-adblock
  tmux
  waybar
  bitwarden-desktop
  wlogout
  banana-cursor
  hyprlock
  wiremix
  pulseaudio
  brightnessctl
  networkmanagerapplet
  glib # gsettings
  gnupg
]
