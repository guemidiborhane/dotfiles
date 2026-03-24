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

  flake.homeModules.pkgs-desktop =
    { inputs, pkgs, ... }:
    {
      home.packages = with pkgs; [
        pkgs.nur.repos.nltch.spotify-adblock
        banana-cursor
        hyprlock
        wiremix
        pulseaudio
        brightnessctl
        networkmanagerapplet
        inputs.wlctl.packages.${pkgs.stdenv.hostPlatform.system}.default
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
        tor-browser
        jellyfin-mpv-shim
        stable.qgis
        xarchiver
        # Communication
        vesktop
        signal-desktop
        telegram-desktop
        thunderbird
      ];
    };
}
