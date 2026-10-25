{ self, ... }:
{
  perSystem =
    { system, ... }:
    let
      # Build output using *our* nixpkgs (our overlays + our unfree allowlist).
      # The license-agnostic definition lives in `self.overlays.packages`; this
      # is just our flake's concrete build of it for `nix build .#<pkg>`.
      pkgs = self.dex.helpers.mkPkgs system;
    in
    {
      packages = {
        inherit (pkgs)
          spotify-adblock
          pagespeed
          colibri
          vpn
          ;
      };
    };
}
