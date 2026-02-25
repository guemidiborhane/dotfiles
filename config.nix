let
  toml = builtins.fromTOML (builtins.readFile ./config.toml);
  inherit (toml) metadata defaults;

  getUser =
    username: toml.users.${username} or (throw "Unknown user '${username}' referenced in host.users");

  getHost =
    name: h:
    let
      host = {
        features = { };
        power = { };
      }
      // h;

      config =
        defaults.host
        // {
          inherit name;
        }
        // host
        // {
          hostname = host.hostname or name;
          swapSize = "${toString (host.ram + 2)}G";
        };
      features = defaults.features // (defaults.features.${host.type} or { }) // host.features;
      power = defaults.power // host.power;

      users = builtins.listToAttrs (
        map (username: {
          name = username;
          value = getUser username // {
            inherit username;
          };
        }) (config.users or [ ])
      );
    in
    {
      inherit
        config
        features
        power
        users
        ;
    };
in
{
  inherit toml metadata;

  hosts = builtins.attrValues (builtins.mapAttrs getHost toml.hosts);
  systems = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
  ];
  defaultSystem = defaults.host.system;

  hostModules = [ ./host ];
  homeModules = [ ./home ];
}
