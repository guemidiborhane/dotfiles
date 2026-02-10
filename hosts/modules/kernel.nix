{ pkgs, inputs, cfg, ... }: let
  kernelName = cfg.features.kernel or "";
  kernels = {
    linux-latest = pkgs.linuxPackages_latest;
    linux-zen = pkgs.linuxPackages_zen;

    cachyos-latest = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
    cachyos-latest-v3 = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
    cachyos-latest-v4 = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v4;
    cachyos-latest-zen4 = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
  };
in {
  boot.kernelPackages =
    if kernelName != ""
    then kernels.${kernelName}
    else kernels.cachyos-latest;

  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
}
