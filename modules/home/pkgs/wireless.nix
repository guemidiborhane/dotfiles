{ _, ... }:
{
  flake-file.inputs = {
    wlctl.url = "github:aashish-thapa/wlctl";
    wlctl.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.pkgs-wireless =
    {
      lib,
      hardware,
      inputs,
      pkgs,
      ...
    }:
    let
      hasWifi = hardware.wifi or false;
      hasBluetooth = hardware.bluetooth or false;
    in
    {
      home.packages =
        lib.optional hasWifi inputs.wlctl.packages.${pkgs.stdenv.hostPlatform.system}.default
        ++ lib.optional hasBluetooth pkgs.bluetui;
    };
}
