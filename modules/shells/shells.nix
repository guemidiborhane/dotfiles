{ self, ... }:
let
  inherit (self.dex) metadata hosts;
in
{
  perSystem =
    { pkgs, lib, ... }:
    {
      devShells = {
        system = import ./_system.nix {
          inherit pkgs lib;
          inherit metadata hosts;
        };
      };
    };
}
