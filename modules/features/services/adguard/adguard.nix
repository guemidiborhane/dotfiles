{ self, ... }:
let
  port = 5335;
  httpPort = 8053;
in
{
  flake.dex.apps.adguard = {
    module = self.modules.nixos.adguard-service;
    ports = [
      {
        host = port;
        guest = port;
        proto = "both";
      }
      {
        host = httpPort;
        guest = httpPort;
      }
    ];
    # The host resolver must point at the container, not the guest's own
    # loopback. Done host-side because the guest cannot set it for the host.
    host =
      { guestAddress, ... }:
      {
        networking.nameservers = [ "${guestAddress}:${toString port}" ];
      };
    # adguard is itself the host's resolver, so it must not take the generator's
    # default (dial the host) — that would loop back into adguard. Use a raw
    # public resolver for the guest's own system lookups; adguard's DoH upstreams
    # bootstrap independently via bootstrap_dns.
    guest.networking.nameservers = [ "9.9.9.9" "1.1.1.1" ];
  };

  flake.modules.nixos.adguard-service =
    { lib, secrets, ... }:
    {
      services.adguardhome = {
        enable = true;

        settings = {
          http.address = "0.0.0.0:${toString httpPort}";
          dns = {
            inherit port;
            bind_hosts = lib.mkForce [ "0.0.0.0" ];

            upstream_mode = "parallel";
            upstream_dns = [
              "https://security.cloudflare-dns.com/dns-query"
              "tls://security.cloudflare-dns.com"
              "https://dns.quad9.net/dns-query"
              "tls://dns.quad9.net"
            ];
            bootstrap_dns = [
              "9.9.9.10"
              "149.112.112.10"
              "2620:fe::10"
              "2620:fe::fe:10"
            ];
            fallback_dns = [
              "1.1.1.2"
              "1.0.0.2"
            ];
          };

          filters = map (filter: {
            enabled = true;
            inherit (filter) id name url;
          }) (import ./_filters.nix);

          filtering.rewrites = [
            {
              domain = "freedium.cfd";
              answer = "146.103.108.112";
              enabled = true;
            }
          ];

          user_rules = secrets.adguard.user_rules;
        };
      };
    };
}
