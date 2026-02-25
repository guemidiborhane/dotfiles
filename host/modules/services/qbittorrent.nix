{ features, ... }:
{
  services.qbittorrent = {
    enable = features.qbittorrent or false;
    openFirewall = false;
  };
}
