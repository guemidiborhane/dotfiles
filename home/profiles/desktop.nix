{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../modules/gnome-keyring.nix
    ../modules/zen-browser.nix
    ../modules/desktop
    ../modules/services
    ../modules/programs/ghostty.nix
    ../modules/programs/foot.nix
    ../modules/programs/vicinae.nix
    ../modules/programs/zed-editor.nix
  ];

  home.packages = with pkgs; [
    pkgs.nur.repos.nltch.spotify-adblock
    waybar
    banana-cursor
    hyprlock
    wiremix
    pulseaudio
    brightnessctl
    networkmanagerapplet
    inputs.wlctl.packages.${pkgs.stdenv.hostPlatform.system}.default
    bluetui
    dbeaver-bin
    evince
    ffmpegthumbnailer
    gimp
    gnome-disk-utility
    gparted
    inkscape
    libreoffice-fresh
    mission-center
    obs-studio
    viewnior
    anydesk
    teamviewer
    megasync
    sunsetr
    tor-browser
    playerctl
    # Communication
    vesktop
    signal-desktop
    telegram-desktop
    thunderbird
  ];

  programs = {
    wezterm.enable = true;
    wlogout.enable = true;
    mpv.enable = true;
  };
}
