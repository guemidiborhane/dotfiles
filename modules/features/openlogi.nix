{
  flake.modules.nixos.openlogi =
    { inputs, features, pkgs, ... }:
    {
      # Mutually exclusive with solaar; selected via features.logitech.
      programs.openlogi.enable = features.logitech == "openlogi";
    };
}
