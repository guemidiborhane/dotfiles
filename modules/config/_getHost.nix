{
  lib,
  defaults,
  users,
}:
let
  getUser =
    username: users.${username} or (throw "Unknown user '${username}' referenced in host.users");
in
name: host:
let
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

  cascade =
    key:
    lib.foldl lib.recursiveUpdate { } [
      (defaults.${key} or { })
      (defaults.${key}.${host.type} or { })
      (host.${key} or { })
    ];
  hardware = cascade "hardware";
  features = cascade "features";
  power = cascade "power";
  networking = cascade "networking";

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
  inherit self;
  inherit features;
  inherit power;
  inherit users;
  inherit networking;
  inherit hardware;
}
