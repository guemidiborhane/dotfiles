{ self, ... }:
let
  inherit (self.helpers) read;
in
{
  flake.tomlConfigs =
    let
      hosts = read.toml ./hosts.toml;
      users = read.toml ./users.toml;

      removeDefaults = set: builtins.removeAttrs set [ "defaults" ];
    in
    {
      defaults = {
        hardware = read.toml ./hardware.toml;
        features = read.toml ./features.toml;
        users = users.defaults;
        host = hosts.defaults;
      };

      hosts = removeDefaults hosts;
      users = removeDefaults users;
    };
}
