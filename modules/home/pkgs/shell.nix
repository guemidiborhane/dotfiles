{ _, ... }:
{
  flake.modules.homeManager.pkgs-shell =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bind
        fastfetch
        ffmpeg
        gum
        htop
        iftop
        inxi
        iperf3
        jq
        net-tools
        ngrok
        nixfmt
        parallel
        pigz
        pv
        python3
        rsync
        s-tui
        sendme
        speedtest-cli
        steam-run
        stress-ng
        tidy-viewer
        tmux
        traceroute
        wol
        yq
        zip
      ];
    };
}
