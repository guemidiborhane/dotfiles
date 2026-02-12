{ cfg, ... }:
{
  services.qbittorrent = {
    enable = cfg.features.qbittorrent or false;
    openFirewall = false;
  };
}
