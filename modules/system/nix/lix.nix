{ _, ... }:
{
  flake.nixosModules.like-nix =
    { pkgs, ... }:
    let
      version = "latest";
    in
    {
      nixpkgs.overlays = [
        (final: prev: {
          inherit (prev.lixPackageSets."${version}")
            nixpkgs-review
            nix-eval-jobs
            nix-fast-build
            colmena
            ;
        })
      ];

      nix.package = pkgs.lixPackageSets."${version}".lix;
    };
}
