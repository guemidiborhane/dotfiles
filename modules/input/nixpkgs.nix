{ _, ... }:
{
  flake-file.inputs =
    let
      stable = "github:nixos/nixpkgs/nixos-25.11";
      unstable = "github:nixos/nixpkgs/nixos-unstable";
    in
    {
      nixpkgs-stable.url = stable;
      nixpkgs-unstable.url = unstable;

      nixpkgs.url = unstable;
      nixpkgs-lib.follows = "nixpkgs";
    };
}
