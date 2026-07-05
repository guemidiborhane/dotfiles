{ _, ... }:
{
  flake.modules.nixos.pkgs =
    {
      inputs,
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
          nvtopPackages.${hardware.gpu}
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
