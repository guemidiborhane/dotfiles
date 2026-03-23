{ self, ... }:
{
  flake.nixosModules.nix-config =
    {
      inputs,
      pkgs,
      metadata,
      ...
    }:
    {

      imports = with self.nixosModules; [
        nix-substituters
        nix-index-database
      ];

      system.stateVersion = metadata.stateVersion;

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
