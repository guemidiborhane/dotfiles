{ _, ... }:
{
  flake.nixosModules.nix-config =
    { inputs, pkgs, ... }:
    {

      imports = with inputs.self.nixosModules; [
        nix-substituters
        nix-auto-upgrade
        nix-index-database
      ];
      nix = {
        package = pkgs.nixVersions.latest;
        settings = {
          warn-dirty = false;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };
        optimise.automatic = true;
      };
    };
}
