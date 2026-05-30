{ _, ... }:
{
  flake-file.inputs =
    let
      stable = "github:nixos/nixpkgs/nixos-26.05";
      unstable = "github:nixos/nixpkgs/nixos-unstable";
    in
    {
      nixpkgs-stable.url = stable;
      nixpkgs-unstable.url = unstable;

      nixpkgs.url = unstable;
      nixpkgs-lib.follows = "nixpkgs";
    };
}
