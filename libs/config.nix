{ tomlConfig, host, pkgs, lib }:
let
  defaults = tomlConfig.defaults;
in {
  inherit (tomlConfig) user metadata;
  inherit defaults;

  host = host // {
    hostname = host.hostname or host.name;
    swapSize = "${toString (host.ram + 2)}G";
  };

  features = defaults.features // (host.features or { });
  power = defaults.power // (host.power or { });
}
