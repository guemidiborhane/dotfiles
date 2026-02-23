{
  description = "Depressingly Reproducible Hysteria";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOs/nixos-hardware/master";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.vicinae.follows = "vicinae";
    };
    wlctl.url = "github:aashish-thapa/wlctl";
    wlctl.inputs.nixpkgs.follows = "nixpkgs";
    solaar.url = "github:Svenum/Solaar-Flake";
    solaar.inputs.nixpkgs.follows = "nixpkgs";
    salatux.url = "github:guemidiborhane/salatux";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      tomlConfig = builtins.fromTOML (builtins.readFile ./config.toml);

      hosts = builtins.attrValues (
        builtins.mapAttrs (name: hostConfig: hostConfig // { inherit name; }) tomlConfig.hosts
      );

      # Supported systems
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
      ];

      forAllSystems =
        fn:
        nixpkgs.lib.genAttrs systems (
          system:
          fn {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          }
        );
    in
    {
      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt);
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };

      devShells = forAllSystems (
        { pkgs }:
        {
          default = import ./shells {
            inherit pkgs hosts;
            config = tomlConfig;
          };
          mise = import ./shells/mise.nix { inherit pkgs; };
        }
      );

      nixosConfigurations = builtins.listToAttrs (
        map (
          host:
          let
            system = "x86_64-linux";
            pkgs =
              let
                config = {
                  allowBroken = false;
                  allowUnfree = true;
                };

                default = import nixpkgs {
                  overlays = builtins.attrValues (import ./overlays { inherit inputs; });
                  inherit config system;
                };
              in
              default;

            cfg = import ./libs/config.nix {
              inherit tomlConfig host pkgs;
              inherit (nixpkgs) lib;
            };

            h = import ./libs/helpers.nix { inherit pkgs cfg; };
            specialArgs = { inherit inputs cfg h; };
          in
          {
            name = host.hostname or host.name;
            value = nixpkgs.lib.nixosSystem {
              inherit pkgs system specialArgs;
              modules = [
                inputs.disko.nixosModules.disko
                inputs.nur.modules.nixos.default
                inputs.solaar.nixosModules.default
                ./hosts
                inputs.home-manager.nixosModules.home-manager
                (
                  { cfg, lib, ... }:
                  {
                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      extraSpecialArgs = specialArgs;
                      users = builtins.mapAttrs (username: user: {
                        imports = [ ./home ];
                        _module.args.user = user // {
                          inherit username;
                        };
                      }) cfg.users;
                      backupCommand = "trash";
                    };
                  }
                )
              ];
            };
          }
        ) hosts
      );
    };
}
