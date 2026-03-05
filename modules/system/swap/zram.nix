{ _, ... }:
{
  flake.nixosModules.zram-swap =
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
        description = "Disable ZRAM before hibernation to prevent ENOMEM";
        before = [ "systemd-hibernate.service" ];
        wantedBy = [ "systemd-hibernate.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.util-linux}/bin/swapoff /dev/zram0";
        };
      };

      systemd.services.hibernate-zram-post = {
        description = "Re-enable ZRAM after hibernation";
        after = [
          "systemd-hibernate.service"
          "hibernate.target"
        ];
        wantedBy = [ "hibernate.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.util-linux}/bin/swapon /dev/zram0";
        };
      };
    };
}
