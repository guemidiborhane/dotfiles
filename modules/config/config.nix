{ self, lib, ... }:
let
  readToml = file: builtins.fromTOML (builtins.readFile file);

  defaults = readToml ./defaults.toml;
  users = readToml ./users.toml;
  hosts = readToml ./hosts.toml;

  getHost = import ./_getHost.nix { inherit lib defaults users; };
in
{
  flake.dex = {
    inherit defaults users;

    metadata = {
      repository = "https://github.com/guemidiborhane/nixos-config";
      stateVersion = "25.11";
    };

    hosts = builtins.attrValues (builtins.mapAttrs getHost hosts);

    defaultSystem = defaults.host.system;

    hostModules = [ self.modules.nixos.entrypoint ];
    homeModules = [ self.modules.homeManager.entrypoint ];
  };
}
