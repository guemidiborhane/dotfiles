_: {
  flake.unfreePackages = [ "ngrok" ];
  flake.modules.homeManager.shell-tools =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bind
        fastfetch
        ffmpeg
        gum
        htop
        inxi
        iperf3
        jq
        ngrok
        nixfmt
        parallel
        pigz
        pv
        python3
        qbittorrent-nox
        rsync
        s-tui
        sendme
        steam-run
        stress-ng
        tidy-viewer
        traceroute
        wol
        yq
        zip
        pagespeed
        vpn
      ];
    };
}
