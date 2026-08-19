{
  flake-file.inputs.openlogi = {
    url = "github:AprilNEA/OpenLogi";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.openlogi =
    { inputs, ... }:
    {
      imports = [ inputs.openlogi.nixosModules.default ];
      programs.openlogi = {
        enable = true;
        launchAtLogin = true;
      };
    };
}
