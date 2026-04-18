{ _, ... }:
{
  flake.modules.nixos.features-qbittorrent-nox =
    { lib, features, ... }:
    lib.mkIf (features.qbittorrent-nox or false) {
      services.qbittorrent = {
        enable = true;
        openFirewall = false;
      };
    };
}
