let
  loader = import ./configs;
  inherit (loader) defaults users;

  getUser =
    username: users.${username} or (throw "Unknown user '${username}' referenced in host.users");
in
name: h:
let
  host = {
    features = { };
    power = { };
  }
  // h;

  self =
    defaults.host
    // {
      inherit name;
    }
    // host
    // {
      hostname = host.hostname or name;
      swapSize = "${toString (host.ram + 2)}G";
    };

  features = defaults.features // (defaults.features.${host.type} or { }) // (host.features or { });
  power = defaults.power // host.power;
  networking =
    defaults.networking // (defaults.networking.${host.type} or { }) // (host.networking or { });

  users = builtins.listToAttrs (
    map (username: {
      name = username;
      value = getUser username // {
        inherit username;
      };
    }) (self.users or [ ])
  );
in
{
  inherit
    self
    features
    power
    users
    networking
    ;
}
