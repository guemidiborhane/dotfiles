{ _, ... }:
{
  flake-file.inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  flake.substituters.nix-cachyos-kernel = [
    {
      url = "https://attic.xuyh0120.win/lantian";
      key = "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=";
    }
  ];

  flake.nixosModules.kernel =
    {
      inputs,
      host,
      pkgs,
      ...
    }:
    let
      kernelName = host.kernel or "";
      kernels = {
        linux-latest = pkgs.linuxPackages_latest;
        linux-zen = pkgs.linuxPackages_zen;

        cachyos-latest = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
        cachyos-latest-v3 = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
        cachyos-latest-v4 = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v4;
        cachyos-latest-zen4 = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
      };
    in
    {
      boot.kernelPackages = if kernelName != "" then kernels.${kernelName} else kernels.cachyos-latest;
      nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
    };
}
