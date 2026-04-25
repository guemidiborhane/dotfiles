{ lib, ... }:
{
  flake.helpers = {
    utils = {
      pluck = builtins.catAttrs;
      deepMerge = arr: lib.foldl lib.recursiveUpdate { } arr;
    };

    read = {
      toml = path: builtins.fromTOML (builtins.readFile path);
      json = path: builtins.fromJSON (builtins.readFile path);
    };
  };
}
