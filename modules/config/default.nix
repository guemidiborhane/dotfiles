{ self, ... }:
let
  inherit (self.helpers) read;
in
{
  flake.tomlConfigs = {
    defaults = read.toml ./defaults.toml;
    hosts = read.toml ./hosts.toml;
    users = read.toml ./users.toml;
  };
}
