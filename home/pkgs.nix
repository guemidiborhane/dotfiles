{
  pkgs,
  ...
}: with pkgs; [
  pkgs.nur.repos.nltch.spotify-adblock
  tmux
  waybar
  bitwarden-desktop
  banana-cursor
  hyprlock
  wiremix
  pulseaudio
  brightnessctl
  networkmanagerapplet
  glib # gsettings
  gnupg
  impala
  bluetui
]
