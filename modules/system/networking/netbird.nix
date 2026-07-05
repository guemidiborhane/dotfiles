{ _, ... }:
{
  flake.modules.nixos.networking-netbird =
    { features, secrets, ... }:
    let
      netbirdServer = {
        inherit (secrets.netbird) Host;
        Scheme = "https";
      };
    in
    {
      services.netbird = {
        enable = true;
        clients.default = {
          port = features.netbirdPort or 51820;
          config = {
            ManagementURL = netbirdServer;
            AdminURL = netbirdServer;
          };
        };
      };
    };
}
