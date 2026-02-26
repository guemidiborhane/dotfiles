{ _, ... }:
{
  flake.nixosModules.mount-disks =
    { host, lib, ... }:
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
      ) (host.disks or { });
    };
}
