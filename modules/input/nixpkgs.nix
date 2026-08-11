{ lib, ... }:
{
  flake-file.inputs = {
    nixpkgs.url = lib.mkForce "";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs.follows = "nixpkgs-unstable";
    nixpkgs-lib.follows = "nixpkgs";
  };
}
