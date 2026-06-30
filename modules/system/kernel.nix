{ self, lib, ... }:
{
  flake-file.inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  flake = {
    substituters.cachyos-kernel = {
      url = "https://attic.xuyh0120.win/lantian";
      key = "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=";
    };

    overlays.cachyos-kernels = final: prev: {
      customKernels = builtins.listToAttrs (
        lib.mapAttrsToList (
          _: host:
          let
            inherit (host.features.kernel) lto sched opti;

            kernel = prev.cachyosKernels.linux-cachyos-latest;
            kernelName = "linux-cachyos-latest-${sched}-lto-${opti}";
            helpers = prev.callPackage "${self.inputs.nix-cachyos-kernel.outPath}/helpers.nix" { };
          in
          {
            name = kernelName;
            value = helpers.kernelModuleLLVMOverride (
              prev.linuxKernel.packagesFor (
                kernel.override {
                  inherit lto;

                  pname = kernelName;
                  cpusched = sched;
                  processorOpt = opti;
                  configVariant = "linux-cachyos-${sched}";
                }
              )
            );
          }
        ) (self.dex.hosts or { })
      );
    };

    modules.nixos.kernel =
      {
        inputs,
        host,
        features,
        pkgs,
        lib,
        ...
      }:
      let
        inherit (features.kernel) opti sched;

        kernelName = host.kernel or "";
        availableKernels = {
          linux-latest = pkgs.linuxPackages_latest;
          linux-zen = pkgs.linuxPackages_zen;

          cachyos-lts = pkgs.cachyosKernels."linuxPackages-cachyos-lts-lto-${opti}";
          cachyos-latest = pkgs.cachyosKernels."linuxPackages-cachyos-bore-lto-${opti}";
          cachyos-custom = pkgs.customKernels."linux-cachyos-latest-${sched}-lto-${opti}";
        };
        overlay = kernelName: if kernelName == "cachyos-custom" then "default" else "pinned";
      in
      {
        specialisation = builtins.listToAttrs (
          map (kernelName: {
            name = kernelName;
            value = {
              configuration = {
                nixpkgs.overlays = [
                  inputs.nix-cachyos-kernel.overlays.${overlay kernelName}
                  self.overlays.cachyos-kernels
                ];
                boot.kernelPackages = lib.mkForce availableKernels.${kernelName};
              };
            };
          }) (host.additionalKernels or [ ])
        );

        boot.kernelPackages = lib.mkDefault (
          if kernelName != "" then availableKernels.${kernelName} else availableKernels.cachyos-latest
        );
        nixpkgs.overlays = [
          inputs.nix-cachyos-kernel.overlays.${overlay kernelName}
          self.overlays.cachyos-kernels
        ];
      };
  };
}
