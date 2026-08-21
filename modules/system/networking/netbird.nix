{ _, ... }:
{
  flake.modules.nixos.netbird =
    { features, secrets, ... }:
    let
      netbirdServer = {
        inherit (secrets.netbird) Host;
        Scheme = "https";
      };
    in
    {
      dex.persist.directories = [ "/var/lib/netbird" ];

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
