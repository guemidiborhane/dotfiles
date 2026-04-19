{ _, ... }:
{
  flake-file.inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  flake.substituters.nix-cachyos-kernel = [
    {
      url = "https://attic.xuyh0120.win/lantian";
      key = "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=";
    }
  ];

  flake.modules.nixos.kernel =
    {
      inputs,
      host,
      features,
      pkgs,
      lib,
      ...
    }:
    let
      helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" { };
      kernelName = host.kernel or "";
      kernels = {
        linux-latest = pkgs.linuxPackages_latest;
        linux-zen = pkgs.linuxPackages_zen;

        cachyos-latest = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
        cachyos-latest-v3 = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
        cachyos-latest-v4 = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v4;
        cachyos-latest-zen4 = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;
        cachyos-custom = helpers.kernelModuleLLVMOverride (
          pkgs.linuxKernel.packagesFor (
            pkgs.cachyosKernels.linux-cachyos-latest.override {
              inherit (features.kernel) lto;
              pname = "linux-cachyos-latest-${features.kernel.scheduler}-lto-${features.kernel.cpu}";
              cpusched = features.kernel.scheduler;
              processorOpt = features.kernel.cpu;
            }
          )
        );
      };
      overlay = if kernelName == "cachyos-custom" then "default" else "pinned";
    in
    {
      boot.kernelPackages = if kernelName != "" then kernels.${kernelName} else kernels.cachyos-latest;
      nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.${overlay} ];
    };
}
