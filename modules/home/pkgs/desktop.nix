{ _, ... }:
{
  flake.unfreePackages = [
    "anydesk"
    "megasync"
    "teamviewer"
  ];

  flake.modules.homeManager.pkgs-desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        anydesk
        banana-cursor
        bibata-cursors
        brave
        brightnessctl
        dbeaver-bin
        evince
        ffmpegthumbnailer
        gimp
        glib # gsettings
        gnome-disk-utility
        gparted
        hyprshot
        inkscape
        libreoffice-fresh
        libsForQt5.qt5ct
        megasync
        mission-center
        networkmanagerapplet
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
        legcord
        viewnior
        wiremix
        xarchiver
        yaak
      ];
    };
}
