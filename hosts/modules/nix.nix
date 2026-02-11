{ pkgs, ... }:
{
  imports = [
    ./caches.nix
  ];

  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      warn-dirty = false;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    optimise.automatic = true;
  };
}
