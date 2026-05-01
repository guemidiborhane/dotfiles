{ _, ... }:
{
  flake.substituters.nltch-spotify = [
    {
      url = "https://nltch.cachix.org";
      key = "nltch.cachix.org-1:W85YxOt0XRZOP3Yppt+HNz3fXRu6DXgH3Ob9n9A+7Ec=";
    }
  ];

  flake.modules.homeManager.pkgs-desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        anydesk
        banana-cursor
        brave
        brightnessctl
        dbeaver-bin
        evince
        ffmpegthumbnailer
        gimp
        glib # gsettings
        gnome-disk-utility
        gparted
        hyprlock
        hyprshot
        inkscape
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
        satty
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
