{ pkgs, ... }:
{
  imports = [
    ./caches.nix
  ];

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      warn-dirty = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    optimise.automatic = true;
  };
}
