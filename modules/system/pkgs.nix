{ _, ... }:
{
  flake.unfreePackages = [
    "cuda_nvml_dev" # we need this.
  ];

  flake.modules.nixos.pkgs =
    ctx@{ pkgs, config, ... }:
    {
      environment.systemPackages =
        with pkgs;
        [
          wget
          curl
          git
          ripgrep
          fd
          rustup
          libnotify
          bc
          btop
          bandwhich
          lm_sensors
          jq
          config.boot.kernelPackages.cpupower
          trashy
          just
          nvtopPackages.${ctx.hardware.gpu} # because of this.
          wol
          statix
          nix-index
          wireguard-tools
          ntfs3g
          exfatprogs
          squashfsTools
          openssl_3
        ]
        ++ (ctx.host.extraPkgs or [ ]);
    };
}
