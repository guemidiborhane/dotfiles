{ pkgs, meta, ... }: {
  networking = {
    hostName = meta.hostname; # Define your hostname.
    nameservers = [
      "127.0.0.1:8853"
    ];
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      # allowedUDPPorts = [  ];
    };
  };

  services.resolved = {
    enable = true;
    fallbackDns = [
      "9.9.9.9#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
      "1.1.1.1#cloudflare-dns.com"
      "2606:4700:4700::1111#cloudflare-dns.com"
    ];
  };
}
