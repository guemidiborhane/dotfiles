{ _, ... }:
{
  flake-file.inputs = {
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
  };

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
