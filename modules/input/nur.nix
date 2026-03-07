{ _, ... }:
{
  flake-file.inputs = {
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.substituters.nur = [
    {
      url = "https://nix-community.cachix.org";
      key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    }
  ];

  flake.nixosModules.inputs-nur =
    { inputs, ... }:
    {
      imports = [
        inputs.nur.modules.nixos.default
      ];
    };

  flake.homeModules.inputs-nur =
    { inputs, ... }:
    {
      imports = [
        inputs.nur.modules.homeManager.default
      ];
    };
}
