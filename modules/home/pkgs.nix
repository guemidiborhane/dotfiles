{ _, ... }:
{
  flake-file.inputs = {
    salatux.url = "github:guemidiborhane/salatux";
  };
  flake.homeModules.default-pkgs =
    { pkgs, inputs, ... }:
    {
      home.packages = with pkgs; [
        fastfetch
        tmux
        glib # gsettings
        gnupg
        python3
        bind
        gum
        htop
        iftop
        inxi
        iperf3
        jq
        yq
        net-tools
        parallel
        pgcli
        pigz
        pv
        rsync
        stress-ng
        s-tui
        traceroute
        wol
        zip
        ngrok
        sendme
        tidy-viewer
        hyprshot
        satty
        brave
        inputs.salatux.packages.${stdenv.hostPlatform.system}.default
        nixfmt
        speedtest-cli
        imagemagick
        ffmpeg
      ];
    };
}
