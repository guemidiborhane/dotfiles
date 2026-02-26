{ inputs, ... }:
{
  imports = [ inputs.flake-file.flakeModules.dendritic ];

  flake-file = {
    description = "Depressingly Reproducible Hysteria";

    inputs = {
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      nixpkgs-lib.follows = "nixpkgs";

      nixos-hardware.url = "github:NixOs/nixos-hardware/master";

      wlctl.url = "github:aashish-thapa/wlctl";
      wlctl.inputs.nixpkgs.follows = "nixpkgs";

      salatux.url = "github:guemidiborhane/salatux";

      import-tree.url = "github:vic/import-tree";
      flake-parts.url = "github:hercules-ci/flake-parts";
      flake-file.url = "github:vic/flake-file";
    };
  };
}
