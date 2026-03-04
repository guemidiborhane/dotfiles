{ inputs, ... }:
let
  inherit (inputs.self.dex) metadata hosts;
in
{
  perSystem =
    { pkgs, ... }:
    {
      devShells = {
        system = import ./_system.nix { inherit pkgs metadata hosts; };
        mise = import ./_mise.nix { inherit pkgs; };
      };
    };
}
