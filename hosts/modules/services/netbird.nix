{ h, cfg, ... }: let
  netbirdServer = {
    Scheme = "https";
    Host = h.base64.decode "YmlyZC5uZXRzeXMuZHo6NDQz";
  };
in {
  enable = true;
  clients.default = {
    port = cfg.features.netbirdPort or 51820;
    config = {
      ManagementURL = netbirdServer;
      AdminURL = netbirdServer;
    };
  };
}
