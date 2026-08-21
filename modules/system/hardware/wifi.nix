{ _, ... }:
{
  flake-file.inputs = {
    wlctl.url = "github:aashish-thapa/wlctl";
    wlctl.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.wifi =
    { inputs, pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.wlctl.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
