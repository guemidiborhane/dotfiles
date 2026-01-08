{
  description = "Home";

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io"
      "https://hyprland.cachix.org"
      "https://vicinae.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixos-hardware.url = "github:NixOs/nixos-hardware/master";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

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

  outputs = { self, nixpkgs, nix-cachyos-kernel, nixos-hardware, home-manager, disko, nur, ... }@ inputs: let 
    calcSwap = ramGB: "${toString (ramGB + 2)}G";
    hosts = [
      {
        name = "takotsubo";
        hardware = nixos-hardware.nixosModules.dell-latitude-7490;
        disk = "/dev/sda";
        ram = 16;
      }
    ];

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
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = builtins.listToAttrs (map (host:
    let
        arch = "x86_64-linux";
        meta = {
          inherit host;
          username = "borhane";
          hostname = host.name;
          device = host.disk;
          swapSize = calcSwap (host.ram or 16);
        };
    in {
      name = host.name;
      value = nixpkgs.lib.nixosSystem {
        system = arch;
        specialArgs = { inherit inputs meta; };
        modules = [
          ({ pkgs, meta, ... }: {
            boot.kernelPackages = meta.kernel or pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
            nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
          })
          nur.modules.nixos.default
          disko.nixosModules.disko
          ./hosts/disko.nix
          ./hosts/common.nix
          ./hosts/${host.name}/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs meta; };
            home-manager.users.${meta.username} = import ./home;
            home-manager.backupFileExtension = "bak";
          }
        ] ++ (if host ? hardware then [host.hardware] else []);
      };
    })
    hosts);
  };
}
