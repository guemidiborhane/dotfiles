{ _, ... }:
{
  flake.modules.nixos.features-zswap =
    {
      lib,
      pkgs,
      features,
      ...
    }:
    lib.mkIf ((features.zSwap or false) && !(features.zramSwap or false)) {
      boot = {
        kernelModules = [
          "lz4hc"
          "lz4hc_compress"
        ];
        kernelParams = [
          "zswap.enabled=1"
          "zswap.compressor=lz4hc"
          "zswap.max_pool_percent=30"
          "zswap.shrinker_enabled=1"
        ];
      };

      systemd.services.hibernate-zswap-pre = {
        description = "Drain zswap pool before hibernation";
        before = [
          "systemd-hibernate.service"
          "systemd-suspend-then-hibernate.service"
        ];
        wantedBy = [
          "systemd-hibernate.service"
          "systemd-suspend-then-hibernate.service"
        ];
        serviceConfig = {
          Type = "oneshot";
          # Disabling zswap causes kernel to writeback all pages to real swap
          ExecStart = "${pkgs.bash}/bin/sh -c 'echo 0 > /sys/module/zswap/parameters/enabled'";
          ExecStop = "${pkgs.bash}/bin/sh -c 'echo 1 > /sys/module/zswap/parameters/enabled'";
          RemainAfterExit = true;
        };
      };
    };
}
