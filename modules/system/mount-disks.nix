{ _, ... }:
{
  flake.modules.nixos.mount-disks =
    { hardware, lib, ... }:
    {
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
      ) (hardware.mounts or { });
    };
}
