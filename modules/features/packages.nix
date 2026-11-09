_: {
  flake.unfreePackages = [
    "cuda_nvml_dev" # we need this.
  ];

  flake.modules.nixos.extra-packages =
    ctx@{ pkgs, config, ... }:
    {
      environment.systemPackages =
        with pkgs;
        [
          rustup
          libnotify
          bc
          netwatch
          syswatch
          bandwhich
          lm_sensors
          config.boot.kernelPackages.cpupower
          trashy
          nvtopPackages.${ctx.hardware.gpu} # because of this.
          wol
          statix
          nix-index
          squashfsTools
        ]
        ++ (ctx.host.extraPkgs or [ ]);
    };
}
