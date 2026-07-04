{ self, ... }:
{
  flake.modules.nixos.nix-config =
    {
      inputs,
      pkgs,
      metadata,
      lib,
      ...
    }:
    {

      imports = with self.modules.nixos; [
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
          auto-optimise-store = true;
        };
        optimise.automatic = false;
      };
    };
}
