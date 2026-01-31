{ cfg, ... }:
let
  inherit (cfg) host;
in {
  disko.devices = let
    device = host.disk;
    swapSize = "${toString host.swapSize}G";
    vgName = "${host.name}-vg";
  in {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings = {
                allowDiscards = true;
                # keyFile = "/tmp/secret.key"; # Uncomment for automated installs
              };
              content = {
                type = "lvm_pv";
                vg = vgName; # Dynamically set to host.name
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      "${vgName}" = {
        type = "lvm_vg";
        lvs = {
          swap = {
            size = swapSize;
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
                "noatime"
                "discard"
              ];
            };
          };
        };
      };
    };
  };
}
