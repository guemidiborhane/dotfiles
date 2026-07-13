{ _, ... }:
{
  flake.unfreePackages = [
    "cuda_nvml_dev" # we need this.
  ];

  flake.modules.nixos.pkgs =
    {
      pkgs,
      config,
      host,
      hardware,
      ...
    }:
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
          nvtopPackages.${hardware.gpu} # because of this.
          wol
          statix
          nix-index
          wireguard-tools
          ntfs3g
          exfatprogs
          squashfsTools
          openssl_3
        ]
        ++ (host.extraPkgs or [ ]);
    };
}
