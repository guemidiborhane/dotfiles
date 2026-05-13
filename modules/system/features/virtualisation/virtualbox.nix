{ lib, ... }:
{
  flake.modules.nixos.virtualbox =
    { features, ... }:
    lib.mkIf (features.virtualisation.virtualbox or false) {

      virtualisation.virtualbox.host = {
        enable = true;
      };
    };
}
