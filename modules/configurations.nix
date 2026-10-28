{ self, lib, ... }:
let
  inherit (self) dex;
  inherit (dex) helpers;

  configs = lib.mapAttrsToList (
    name: host:
    let
      inherit (host.config) hostname;
    in
    {
      nixos = {
        name = hostname;
        value = helpers.mkHost host;
      };

      # `host.users` carries the `forEach` helper alongside real users (see
      # modules/dex/dex.nix `usersHelpers`); exclude it so it does not become a
      # bogus `forEach@<host>` home configuration.
      homes = lib.mapAttrsToList (username: user: {
        name = "${username}@${hostname}";
        value = helpers.mkHome { inherit host user; };
      }) (builtins.removeAttrs host.users [ "forEach" ]);
    }
  ) dex.hosts;

in
{
  flake = {
    nixosConfigurations = lib.listToAttrs (map (c: c.nixos) configs);
    homeConfigurations = lib.listToAttrs (lib.flatten (map (c: c.homes) configs));
  };
}
