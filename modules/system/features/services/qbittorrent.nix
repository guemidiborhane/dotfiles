{ _, ... }:
{
  flake.nixosModules.features-qbittorrent =
    { lib, features, ... }:
    lib.mkIf (features.qbittorrent or false) {
      services.qbittorrent = {
        enable = true;
        openFirewall = false;
      };
    };
}
