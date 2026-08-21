{ self, ... }:
{
  flake.modules.nixos.nix-config =
    { pkgs, lib, metadata, hardware, ... }:
    {
      system.stateVersion = metadata.stateVersion;

      nix = {
        package = lib.mkDefault pkgs.nixVersions.latest;
        settings = {
          warn-dirty = false;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          auto-optimise-store = hardware.isBareMetal;
        };
        optimise.automatic = false;
      };
    };
}
