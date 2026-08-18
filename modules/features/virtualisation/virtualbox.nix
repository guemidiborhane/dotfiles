{ lib, ... }:
{
  flake.modules.nixos.virtualbox =
    { features, ... }:
    lib.mkIf (features.virtualbox or false) {

      virtualisation.virtualbox.host = {
        enable = true;
      };
    };
}
