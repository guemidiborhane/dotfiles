{ _, ... }:
{
  flake-file.inputs = {
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.nix-index-database =
    { inputs, ... }:
    {
      imports = [ inputs.nix-index-database.nixosModules.default ];
      programs.nix-index-database.comma.enable = true;
    };
}
