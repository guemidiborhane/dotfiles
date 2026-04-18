{ _, ... }:
{
  flake.modules.nixos.features-zram-swap =
    {
      lib,
      pkgs,
      features,
      ...
    }:
    lib.mkIf ((features.zramSwap or false) && !(features.zSwap or false)) {
      zramSwap = {
        enable = true;
        priority = 100;
        algorithm = "lz4";
        memoryPercent = 30;
      };

      systemd.services.hibernate-zram-pre = {
        description = "Disable ZRAM before hibernation";
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
          ExecStart = "${pkgs.util-linux}/bin/swapoff /dev/zram0";
          RemainAfterExit = true;
        };
      };

      # kinda redundant but better safe than sorry, already handled by systemd-zram-setup@zram0.service
      systemd.services.hibernate-zram-post = {
        description = "Re-enable ZRAM after resume from hibernation";
        after = [
          "hibernate.target"
          "suspend-then-hibernate.target"
        ];
        wantedBy = [
          "hibernate.target"
          "suspend-then-hibernate.target"
        ];
        serviceConfig = {
          Type = "oneshot";
          # Ignore exit code 255 (already active)
          ExecStart = "${pkgs.util-linux}/bin/swapon --priority 100 /dev/zram0";
          SuccessExitStatus = "0 255";
        };
      };
    };
}
