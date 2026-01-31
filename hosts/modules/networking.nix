{ cfg, h, ... }:
{
  networking = {
    hostName = cfg.host.hostname;
    nameservers = [ "127.0.0.1:8853" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 3000 ];
    };
    networkmanager = h.enabled;
  };

  services.resolved = {
    enable = true;
    settings.Resolve.FallbackDNS = [
      "9.9.9.9#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
      "1.1.1.1#cloudflare-dns.com"
      "2606:4700:4700::1111#cloudflare-dns.com"
    ];
  };

  services.netbird = import ../modules/services/netbird.nix { inherit h; };
}
