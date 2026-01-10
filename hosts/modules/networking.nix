{ pkgs, meta, lib, ... }: {
  networking = {
    hostName = meta.hostname; # Define your hostname.
    nameservers = [
      "127.0.0.1:8853"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      # allowedUDPPorts = [  ];
    };
  };

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    # FIX: netbird connections should be handled separately by `~/.local/bin/vpn`,
    # instead of relying on nm
    unmanaged = lib.mkForce [];
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.resolved = {
    enable = true;
    fallbackDns = [
      "9.9.9.9#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
      "1.1.1.1#cloudflare-dns.com"
      "2606:4700:4700::1111#cloudflare-dns.com"
    ];
  };

  services.netbird = {
    enable = true;
    clients.default.config = {
      ManagementURL.Host = "bird.netsys.dz:443";
      AdminURL.Host = "bird.netsys.dz:443";
    };
  };
}
