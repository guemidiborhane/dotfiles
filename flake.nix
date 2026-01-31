{
  description = "NixOS Configuration";

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

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";
    vicinae.url = "github:vicinaehq/vicinae";
    wlctl.url = "github:aashish-thapa/wlctl";
    wlctl.inputs.nixpkgs.follows = "nixpkgs";
    solaar.url = "github:Svenum/Solaar-Flake";
    solaar.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
    # Parse configuration
    tomlConfig = builtins.fromTOML (builtins.readFile ./config.toml);

    # Extract hosts
    hosts = builtins.attrValues (builtins.mapAttrs (name: hostConfig:
      hostConfig // { inherit name; })
    tomlConfig.hosts);

    # Supported systems
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    forAllSystems = fn:
      nixpkgs.lib.genAttrs systems (system: fn {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      });
  in {
    formatter = forAllSystems ({ pkgs }: pkgs.alejandra);
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    overlays = import ./overlays { inherit inputs; };

    devShells = forAllSystems ({ pkgs }: {
      default = import ./shell.nix { inherit pkgs; };
    });

    nixosConfigurations = builtins.listToAttrs (map (host: let
      hardwareModules =
        if host ? hardware && host.hardware != ""
        then [inputs.nixos-hardware.nixosModules.${host.hardware}]
        else [];

      system = "x86_64-linux";
      pkgs = let
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

      helpers = import ./libs/helpers.nix { inherit pkgs cfg; };
      specialArgs = { inherit inputs helpers cfg; };
    in {
      name = host.hostname or host.name;
      value = nixpkgs.lib.nixosSystem {
        inherit pkgs system specialArgs;
        modules = [
          # Core modules
          inputs.disko.nixosModules.disko

          # System configuration
          ./hosts/disko.nix
          ./hosts/common.nix
          ./hosts/${host.name}/hardware-configuration.nix
          ./hosts/modules/kernel.nix
          ./hosts/modules/nix.nix

          # Additional modules
          inputs.nur.modules.nixos.default
          inputs.solaar.nixosModules.default
          ./hosts/modules/base-devel.nix
          ./hosts/modules/networking.nix
          ./hosts/modules/virtualisation
          ./hosts/modules/user.nix
          ./hosts/modules/pkgs.nix
          ./hosts/modules/services
          ./hosts/modules/programs
          ./hosts/modules/kanata.nix
          ./hosts/modules/auto-upgrade.nix
          ./hosts/profiles/${host.type}.nix

          # Home manager
          inputs.home-manager.nixosModules.home-manager
          ({ cfg, ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${cfg.user.username} = import ./home;
            home-manager.backupCommand = "trash";
          })

          # State version
          ({ cfg, ... }: {
            system.stateVersion = cfg.metadata.stateVersion;
          })
        ] ++ hardwareModules;
      };
    })
    hosts);
  };
}
