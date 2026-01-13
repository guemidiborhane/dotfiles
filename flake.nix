{
  description = "Home";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixos-hardware.url = "github:NixOs/nixos-hardware/master";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    vicinae.url = "github:vicinaehq/vicinae";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-cachyos-kernel,
    nixos-hardware,
    home-manager,
    disko,
    nur,
    ...
  } @ inputs: let
    # Parse configuration
    cfg = builtins.fromTOML (builtins.readFile ./config.toml);

    # Extract hosts
    hosts = builtins.attrValues (builtins.mapAttrs (name: hostConfig:
      hostConfig // { inherit name; })
    cfg.hosts);

    calcSwap = ramGB: "${toString (ramGB + 2)}G";

    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: fn {pkgs = import nixpkgs {inherit system;};});

  in {
    formatter = forAllSystems ({pkgs}: pkgs.alejandra);
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    overlays = import ./overlays { inherit inputs; };

    # Development shell
    devShells = forAllSystems ({ pkgs }: {
      default = import ./shell.nix { inherit pkgs; };
    });

    nixosConfigurations = builtins.listToAttrs (map (host: let
      meta = {
        inherit host;
        swapSize = "${toString (host.ram + 2)}G";
      };

      hardwareModules =
        if host ? hardware && host.hardware != ""
        then [nixos-hardware.nixosModules.${host.hardware}]
        else [];

      typeModules =
        if host.type == "headless"
        then [./hosts/profiles/headless.nix]
        else if host.type == "laptop"
        then [./hosts/profiles/laptop.nix]
        else if host.type == "desktop"
        then [./hosts/profiles/desktop.nix]
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
      helpers = import ./libs/helpers.nix { inherit pkgs; };
    in {
      name = host.name;
      value = nixpkgs.lib.nixosSystem {
        inherit pkgs system;
        specialArgs = { inherit inputs meta helpers cfg; };
        modules =
          [
            # Kernel configuration
            ({pkgs, ...}: {
              boot.kernelPackages =
                if host.features.kernel or null != null
                then pkgs.cachyosKernels."linuxPackages-${host.features.kernel}"
                else pkgs.cachyosKernels.linuxPackages-cachyos-latest;
              nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];
            })

            # Core modules
            nur.modules.nixos.default
            disko.nixosModules.disko

            # System configuration
            ./hosts/disko.nix
            ./hosts/common.nix
            ./hosts/${host.name}/hardware-configuration.nix

            # Additional modules
            ./hosts/modules/nix.nix
            ./hosts/modules/base-devel.nix
            ./hosts/modules/networking.nix
            ./hosts/modules/virtualisation
            ./hosts/modules/user.nix
            ./hosts/modules/pkgs.nix
            ./hosts/modules/services
            ./hosts/modules/programs
            ./hosts/modules/hyprland.nix
            ./hosts/modules/kanata.nix

            # Home manager
            home-manager.nixosModules.home-manager
            ({
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs meta helpers cfg; };
              home-manager.users.${cfg.user.username} = import ./home;
              home-manager.backupCommand = "trash";
            })

            # State version
            ({ cfg, ... }: {
              system.stateVersion = cfg.metadata.stateVersion;
            })
          ]
          ++ hardwareModules;
      };
    })
    hosts);
  };
}
