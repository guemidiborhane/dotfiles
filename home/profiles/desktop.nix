{ pkgs, inputs, meta, helpers, ... }:
{
  imports = [
    ../modules/gnome-keyring.nix
    ../modules/zen-browser.nix
    ../modules/desktop
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
    localsend
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

  programs.ghostty = import ../modules/programs/ghostty.nix;
  programs.foot = import ../modules/programs/foot.nix;
  programs.vicinae = import ../modules/programs/vicinae.nix { inherit pkgs inputs; };
  programs.zed-editor = import ../modules/programs/zed.nix { inherit pkgs meta; };

  services = import ../modules/services { inherit pkgs helpers; };

  programs = {
    wezterm = helpers.enabled;
    wlogout = helpers.enabled;
    mpv = helpers.enabled;
  };
}
