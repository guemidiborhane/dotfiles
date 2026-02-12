{
  tomlConfig,
  host,
  pkgs,
  lib,
}:
let
  inherit (tomlConfig) defaults;
in
{
  inherit (tomlConfig) user metadata;
  inherit defaults;

  host =
    (defaults.host or { })
    // host
    // {
      hostname = host.hostname or host.name;
      swapSize = "${toString (host.ram + 2)}G";
    };

  features = defaults.features // (defaults.features.${host.type} or { }) // (host.features or { });
  power = defaults.power // (host.power or { });
}
