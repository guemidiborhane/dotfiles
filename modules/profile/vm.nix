{ self, ... }:
{
  flake.modules = {
    nixos.vm-profile =
      {
        inputs,
        lib,
        pkgs,
        host,
        users,
        ...
      }:
      {
        imports = with self.modules.nixos; [ headless-profile ];

        boot.kernelPackages = pkgs.linuxPackages_zen;

        # Disable firewall for faster boot and less hassle;
        # we are behind a layer of NAT anyway.
        networking.firewall.enable = lib.mkForce false;
        security.sudo.wheelNeedsPassword = false;

        systemd = {
          network = {
            enable = lib.mkForce true;

            # Static addressing instead of DHCP.
            networks."10-microvm" = {
              networkConfig = {
                DNS = [
                  "1.1.1.1"
                  "8.8.8.8"
                ];
                DHCP = "no";
              };
            };
          };

          # fast shutdowns/reboots! https://mas.to/@zekjur/113109742103219075
          settings.Manager.DefaultTimeoutStopSec = "5s";

          # Fix for microvm shutdown hang (issue #170):
          # Without this, systemd tries to unmount /nix/store during shutdown,
          # but umount lives in /nix/store, causing a deadlock.
          mounts = [
            {
              what = "store";
              where = "/nix/store";
              overrideStrategy = "asDropin";
              unitConfig.DefaultDependencies = false;
            }
          ];
        };

        microvm = {
          # Enable writable nix store overlay so nix-daemon works.
          # This is required for home-manager activation.
          # Uses tmpfs by default (ephemeral), which is fine since we
          # don't build anything in the VM.
          writableStoreOverlay = "/nix/.rw-store";

          shares =
            let
              pathToShareKey =
                path:
                let
                  str = toString path;
                  cleaned = lib.removeSuffix "/" (lib.removePrefix "/" str);
                in
                lib.toLower (lib.replaceStrings [ "/" ] [ "_" ] cleaned);
            in
            [
              {
                proto = "virtiofs";
                tag = "ro-store";
                readOnly = true;
                # a host's /nix/store will be picked up so that no
                # squashfs/erofs will be built for it.
                source = "/nix/store";
                mountPoint = "/nix/.ro-store";
              }
            ]
            ++ (map (share: {
              proto = "virtiofs";
              tag = pathToShareKey share.host;
              source = share.host;
              mountPoint = share.guest;
            }) (host.shares or [ ]));

          hypervisor = "qemu";
        };
      };

    homeManager.vm-profile = { user, ... }: { };
  };
}
