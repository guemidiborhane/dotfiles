_: {
  flake = {
    unfreePackages = [
      "anydesk"
      "megasync"
      "teamviewer"
      "spotify"
    ];
    modules.homeManager.pkgs-desktop =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          anydesk
          banana-cursor
          bibata-cursors
          brave-origin
          brightnessctl
          evince
          ffmpegthumbnailer
          gimp
          glib # gsettings
          gnome-disk-utility
          gparted
          inkscape
          libreoffice-stable
          libsForQt5.qt5ct
          megasync
          mission-center
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
          imv
          wiremix
          xarchiver
          spotify-adblock
        ];
      };
  };
}
