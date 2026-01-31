{ h, ... }: let
  netbirdServer = {
    Scheme = "https";
    Host = h.base64.decode "YmlyZC5uZXRzeXMuZHo6NDQz";
  };
in {
  enable = true;
  clients.default = {
    config = {
      ManagementURL = netbirdServer;
      AdminURL = netbirdServer;
    };
  };
}
