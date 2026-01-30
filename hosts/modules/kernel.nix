{ pkgs, inputs, cfg, ... }:
{
  boot.kernelPackages =
    if cfg.features.kernel or null != null
    then pkgs.cachyosKernels."linuxPackages-${cfg.features.kernel}"
    else pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
}
