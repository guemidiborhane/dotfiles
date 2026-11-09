_: {
  flake.modules.nixos.mount-disks =
    { hardware, lib, ... }:
    {
      fileSystems = builtins.listToAttrs (
        map (
          m:
          lib.nameValuePair (builtins.elemAt m 1) {
            device = "/dev/disk/by-uuid/${builtins.elemAt m 0}";
            fsType = "auto";
            options = [
              "nosuid"
              "nodev"
              "nofail"
              "x-gvfs-show"
            ];
          }
        ) (hardware.mounts or [ ])
      );
    };
}
