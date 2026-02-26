{ _, ... }:
{
  flake.nixosModules.networking-resolved =
    { _, ... }:
    {
      services.resolved = {
        enable = true;
        settings.Resolve.FallbackDNS = [
          "9.9.9.9#dns.quad9.net"
          "2620:fe::9#dns.quad9.net"
          "1.1.1.1#cloudflare-dns.com"
          "2606:4700:4700::1111#cloudflare-dns.com"
        ];
      };
    };
}
