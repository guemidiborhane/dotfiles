{ lib, ... }:
{
  options.flake.helpers = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = { };
    description = "Helper functions exposed at the flake level";
  };
}
