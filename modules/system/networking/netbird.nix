{ _, ... }:
{
  flake.modules.nixos.networking-netbird =
    { h, networking, ... }:
    let
      netbirdServer = {
        Scheme = "https";
        Host = h.base64.decode "YmlyZC5uZXRzeXMuZHo6NDQz";
      };
    in
    {
      services.netbird = {
        enable = true;
        clients.default = {
          port = networking.netbirdPort or 51820;
          config = {
            ManagementURL = netbirdServer;
            AdminURL = netbirdServer;
          };
        };
      };
    };
}
