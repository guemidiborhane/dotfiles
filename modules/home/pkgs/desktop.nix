{ _, ... }:
{
  flake-file.inputs = {
    wlctl.url = "github:aashish-thapa/wlctl";
    wlctl.inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.substituters.wlctl = [
    {
      url = "https://nltch.cachix.org";
      key = "nltch.cachix.org-1:W85YxOt0XRZOP3Yppt+HNz3fXRu6DXgH3Ob9n9A+7Ec=";
    }
  ];

  flake.modules.homeManager.pkgs-desktop =
    { inputs, pkgs, ... }:
    {
      home.packages = with pkgs; [
        anydesk
        banana-cursor
        brightnessctl
        dbeaver-bin
        evince
        ffmpegthumbnailer
        gimp
        gnome-disk-utility
        gparted
        hyprlock
        inkscape
        inputs.wlctl.packages.${pkgs.stdenv.hostPlatform.system}.default
        jellyfin-mpv-shim
        libreoffice-fresh
        libsForQt5.qt5ct
        megasync
        mission-center
        networkmanagerapplet
        nur.repos.nltch.spotify-adblock
        nur.repos.trev.helium
        obs-studio
        pulseaudio
        qbittorrent
        signal-desktop
        stable.qgis
        teamviewer
        telegram-desktop
        thunderbird
        tor-browser
        vesktop
        viewnior
        wiremix
        xarchiver
        yaak
      ];
    };
}
