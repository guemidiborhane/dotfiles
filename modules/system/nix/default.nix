{ self, ... }:
{
  flake.nixosModules.nix-config =
    {
      inputs,
      pkgs,
      metadata,
      lib,
      ...
    }:
    {

      imports = with self.nixosModules; [
        nix-substituters
        nix-index-database
        like-nix
      ];

      system.stateVersion = metadata.stateVersion;

      nix = {
        package = lib.mkDefault pkgs.nixVersions.latest;
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
