{ _, ... }:
{
  flake.nixosModules.services-qbittorrent =
    { features, ... }:
    {
      services.qbittorrent = {
        enable = features.qbittorrent or false;
        openFirewall = false;
      };
    };
}
