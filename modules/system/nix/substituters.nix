# NOTE: Before using the cache you should rebuild to add it to the config
{ lib, config, ... }:
{
  options.flake.substituters = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.listOf (
        lib.types.submodule {
          options = {
            url = lib.mkOption {
              type = lib.types.str;
              description = "Substituter URL";
            };
            key = lib.mkOption {
              type = lib.types.str;
              description = "Public key for substituter";
            };
          };
        }
      )
    );
    default = { };
    description = "Binary cache substituters declared by modules";
  };

  config = {
    flake.nixosModules.nix-substituters =
      { inputs, ... }:
      let
        allCaches = lib.flatten (lib.attrValues config.flake.substituters);

        urls = map (s: s.url) allCaches;
        keys = map (s: s.key) allCaches;
      in
      {
        nix.settings = {
          extra-substituters = urls;
          extra-trusted-substituters = urls;
          extra-trusted-public-keys = keys;
        };
      };
  };
}
