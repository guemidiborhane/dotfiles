{ self, lib, ... }:
{
  options.flake.secrets = lib.mkOption {
    type = lib.types.raw;
    default = { };
    description = "Non-public configuration values, read from git-crypt encrypted secrets.toml.";
  };

  config.flake.secrets = self.helpers.read.toml ./secrets.toml;
}
