{ _, ... }:
{
  flake-file.inputs = {
    solaar.url = "github:Svenum/Solaar-Flake";
    solaar.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.inputs-solaar =
    { inputs, ... }:
    {
      imports = [
        inputs.solaar.nixosModules.default
      ];
    };
}
