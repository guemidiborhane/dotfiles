{ _, ... }:
{
  flake-file.inputs = {
    wlctl.url = "github:aashish-thapa/wlctl";
    wlctl.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.homeModules.pkgs-desktop =
    { inputs, pkgs, ... }:
    {
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
        jellyfin-mpv-shim
        qgis
        # Communication
        vesktop
        signal-desktop
        telegram-desktop
        thunderbird
      ];
    };
}
