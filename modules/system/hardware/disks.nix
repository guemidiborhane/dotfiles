{ _, ... }:
{
  flake.nixosModules.hardware-disks =
    { hardware, lib, ... }:
    lib.mkIf (hardware ? disks && hardware.disks != [ ]) {
      fileSystems = lib.mapAttrs' (
        diskId: mountPath:
        lib.nameValuePair mountPath {
          device = "/dev/disk/by-uuid/${diskId}";
          fsType = "auto";
          options = [
            "nosuid"
            "nodev"
            "nofail"
            "x-gvfs-show"
          ];
        }
      ) hardware.disks;
    };
}
