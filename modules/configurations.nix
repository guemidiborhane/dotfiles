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

      homes = lib.mapAttrsToList (username: user: {
        name = "${username}@${hostname}";
        value = helpers.mkHome { inherit host user; };
      }) host.users;
    }
  ) dex.hosts;

in
{
  flake = {
    nixosConfigurations = lib.listToAttrs (map (c: c.nixos) configs);
    homeConfigurations = lib.listToAttrs (lib.flatten (map (c: c.homes) configs));
  };
}
