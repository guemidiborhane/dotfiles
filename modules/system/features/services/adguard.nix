{ _, ... }:
{
  flake.modules.nixos.adguard =
    ctx@{ lib, config, ... }:
    with ctx;
    let
      cfg = config.services.adguardhome.settings;
    in
    lib.mkIf (features.adguard or false) {
      networking.nameservers = [ "127.0.0.1:${toString cfg.dns.port}" ];
      services.adguardhome = {
        enable = true;
        port = 8053;

        settings = {
          dns = {
            port = 5353;
            bind_hosts = [ "127.0.0.1" ];
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
            upstream_mode = "parallel";
          };

          filtering.safe_fs_patterns = [ "/var/lib/AdGuardHome/userfilters/*" ];

          filters = [
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
              name = "AdGuard DNS filter";
              id = 1;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt";
              name = "AdGuard DNS Popup Hosts filter";
              id = 1752367266;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_4.txt";
              name = "Dan Pollock's List";
              id = 1752367267;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_49.txt";
              name = "HaGeZi's Ultimate Blocklist";
              id = 1752367268;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_27.txt";
              name = "OISD Blocklist Big";
              id = 1752367269;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt";
              name = "Peter Lowe's Blocklist";
              id = 1752367270;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt";
              name = "Steven Black's List";
              id = 1752367271;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_12.txt";
              name = "Dandelion Sprout's Anti-Malware List";
              id = 1752367273;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_55.txt";
              name = "HaGeZi's Badware Hoster Blocklist";
              id = 1752367274;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_44.txt";
              name = "HaGeZi's Threat Intelligence Feeds";
              id = 1752367276;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_18.txt";
              name = "Phishing Army";
              id = 1752367277;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_42.txt";
              name = "ShadowWhisperer's Malware List";
              id = 1752367278;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_31.txt";
              name = "Stalkerware Indicators List";
              id = 1752367279;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt";
              name = "uBlock₀ filters – Badware risks";
              id = 1752367280;
            }
            {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt";
              name = "Malicious URL Blocklist (URLHaus)";
              id = 1752367281;
            }
          ];

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
