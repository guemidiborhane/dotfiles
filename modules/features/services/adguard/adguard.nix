{ _, ... }:
{
  flake.modules.nixos.adguard =
    { secrets, ... }:
    let
      port = 5353;
    in
    {
      networking.nameservers = [ "127.0.0.1:${toString port}" ];

      services.adguardhome = {
        enable = true;
        port = 8053;

        settings = {
          dns = {
            inherit port;
            bind_hosts = [ "127.0.0.1" ];

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
