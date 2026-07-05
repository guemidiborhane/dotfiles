{ _, ... }:
{
  flake-file.inputs = {
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake = {
    substituters = {
      nix-community = {
        url = "https://nix-community.cachix.org";
        key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
      };
      nltch-nur = {
        url = "https://nltch.cachix.org";
        key = "nltch.cachix.org-1:W85YxOt0XRZOP3Yppt+HNz3fXRu6DXgH3Ob9n9A+7Ec=";
      };
    };

    modules.nixos.nur =
      { inputs, ... }:
      {
        imports = [
          inputs.nur.modules.nixos.default
        ];
      };

    modules.homeManager.nur =
      { inputs, pkgs, ... }:
      {
        imports = [
          inputs.nur.modules.homeManager.default
        ];

        home.packages = with pkgs.nur.repos; [
          nltch.spotify-adblock
          trev.helium
        ];
      };
  };
}
