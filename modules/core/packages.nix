_: {
  flake.modules.nixos.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        wget
        curl
        git
        ripgrep
        fd
        jq
        just
        btop
        ntfs3g
        exfatprogs
        wireguard-tools
      ];
    };
}
