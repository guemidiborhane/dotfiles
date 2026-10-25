{
  flake-file.inputs.openlogi = {
    url = "github:AprilNEA/OpenLogi";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.openlogi =
    { inputs, features, ... }:
    {
      imports = [ inputs.openlogi.nixosModules.default ];
      programs.openlogi = {
        # Mutually exclusive with solaar; selected via features.logitech.
        enable = features.logitech == "openlogi";
        launchAtLogin = true;
      };
    };
}
