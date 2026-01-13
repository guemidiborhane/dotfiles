{ pkgs, ... }:
let 
  caches = import ./caches.nix;
in {
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      warn-dirty = false;
      experimental-features = [ "nix-command" "flakes" ];

      extra-substituters = map (c: c.url) caches;
      extra-trusted-substituters = map (c: c.url) caches;
      extra-trusted-public-keys = map (c: c.key) caches;
    };
  };
}
